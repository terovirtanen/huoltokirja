using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model.Note
{
    internal class Note : INote
    {
        public string Title { get; set; }
        public string Description { get; set; }
        public DateTime EventTime { get; set; }
        public int Counter { get; set; }

        public NoteStatus Status { get; set; }

        static public List<INote> Items = null;

        [JsonIgnore]
        public string ListText { get; protected set; }

        [JsonIgnore]
        public string ListTextAllNotes { get; protected set; }

        [JsonIgnore]
        public IDependant Dependant { get; set; }


        public virtual void SetOutputText()
        {
            var eventtime = getEventTimeForOutput();
            var ownerName = (Dependant != null) ? " " + Dependant.Name : "";

            ListText = eventtime + " " + Title + " " + Description;
            ListTextAllNotes = eventtime + ownerName + " " + Title + " " + Description;

            NoteListTextChanged?.Invoke(this, EventArgs.Empty);
        }
        public Note()
        {
        }

        public Note(string title, string description, DateTime eventTime)
        {
            Title = title;
            Description = description;
            EventTime = eventTime;

            SetOutputText();
        }
        protected string getEventTimeForOutput()
        {
            var emptyDate = new DateTime();

            string eventtime = (EventTime != emptyDate) ? EventTime.ToString("dd.MM.yyyy") : "";
            return eventtime;
        }
        public Note(string title, string description = "") : this(title, description, DateTime.Now)
        {
        }

        public void AddToItems()
        {
            if (Items == null) { Items = new List<INote>(); }
            if (! Items.Contains(this))
            {
                Items.Add(this);
            }
        }
        public void RemoveFromItems()
        {
            if (Items == null) { return; }
            if (Items.Contains(this))
            {
                Items.Remove(this);
            }
        }
        public Color ListColor()
        {
            if (EventTime > DateTime.Now) { return Color.Green; }
            if (EventTime < DateTime.Now && Status == NoteStatus.SCHEDULED ) { return Color.Red; }
            return Color.White;
        }

        public event EventHandler NoteListTextChanged;

    }
}
