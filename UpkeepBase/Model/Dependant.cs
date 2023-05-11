using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Forms.Model.Scheduler;
using UpkeepBase.Model.Note;

namespace UpkeepBase.Model
{
    public class Dependant : IDependant
    {
        public string Id { get; set; }
        public string Name { get; set; }
        public string[] Tags { get; set; }
        public string TagsString { get; set; }
        public string CounterUnit { get; set; }
        public DateTime EventTime { get; set; }

        public List<INote> NItems { get; set; }

        public List<IScheduler> SItems { get; set; }

        [JsonIgnore]
        public List<INote> NItemsOrderByDescendingByEventTime { get { return NItems.OrderByDescending(note => note.EventTime).ToList(); } }

        [JsonIgnore]
        public List<IScheduler> SItemsOrderByByEventTime { get { return SItems.OrderBy(scheduler => scheduler.NextScheduleTime).ToList(); } }

        [JsonIgnore]
        public string CounterEstimate { get; set; }

        public Dependant()
        {
            NItems = new List<INote>();
            SItems = new List<IScheduler>();
        }
        public Dependant(string name, string tags, DateTime eventTime)
        {
            this.Name = name;
            this.AddTags(tags);
            this.EventTime = eventTime;

            this.NItems = new List<INote>();
        }
        public void AddTags(string tags)
        {
            if (tags != null && tags.Length > 0)
            {
                this.Tags = tags.Split(' ');
                TagsString = String.Concat(this.Tags);
            }
        }

        public INote AddNote(string title, string description = "")
        {
            var note = new Note.Note(title, description);
            return setNote(note);
        }
        private INote addNote(string title, string description, DateTime eventTime)
        {
            var note = new Note.Note(title, description, eventTime);
            return setNote(note);
        }
        public INote AddService(string title,
            string description = "",
            string fixer = "",
            double price = 0.0,
            int counter = 0)
        {
            var note = new Note.Service(title, description);
            if (fixer != "") note.Fixer = fixer;
            if (price > 0.0) note.Price = price;
            if (counter > 0) note.Counter = counter;

            return setNote(note);
        }
        private INote addService(string title, string description, DateTime eventTime)
        {
            var note = new Note.Service(title, description, eventTime);
            note.Status = NoteStatus.UPDATED;
            return setNote(note);
        }
        public INote AddInspection(bool pass, string description = "")
        {
            var note = new Note.Inspection(pass, description);
            note.Status = NoteStatus.UPDATED;
            return setNote(note);
        }
        private INote addInspection(bool pass, string description, DateTime eventTime)
        {
            var note = new Note.Inspection(pass, description, eventTime);
            note.Status = NoteStatus.UPDATED;
            return setNote(note);
        }
        private INote setNote(INote note)
        {
            note.Dependant = this;

            // Notes.Add(note);
            NItems.Add(note);
            note.AddToItems();

            return note;
        }
        public INote AddNoteFromScheduler(NoteTypes noteType, string title, string description, DateTime eventtime)
        {
            INote note = null;

            if (noteType == NoteTypes.BASIC)
            {
                note = addNote(title, description, eventtime);
            }
            else if (noteType == NoteTypes.SERVICE)
            {
                note = addService(title, description, eventtime);
            }
            else if (noteType == NoteTypes.INSPECTION)
            {
                note = addInspection(false, description, eventtime);
            }

            note.Status = NoteStatus.SCHEDULED;

            return note;
        }
        public void RemoveNote(INote note)
        {
            if (note == null) return;

            note.RemoveFromItems();
            NItems.Remove(note);
        }
        public void AddScheduler(IScheduler scheduler)
        {
            scheduler.Dependant = this;
            if (SItems.Contains(scheduler)) return;

            SItems.Add(scheduler);
        }
        public void RemoveScheduler(IScheduler scheduler)
        {
            if (scheduler == null) return;

            SItems.Remove(scheduler);
        }
        public void CalculateCounterEstimate()
        {
            if (CounterUnit == null || CounterUnit == "")
            {
                CounterEstimate = "";
                return;
            }

            var estimate = calcCounterEstimate();

            CounterEstimate = "Arvio nyt " + Math.Ceiling(estimate) + " " + CounterUnit;
        }
        public double CounterIncreaseInDay()
        {
            var calculated = calculateIncreaseInDay();

            return calculated.increaseInDay;
        }

        public INote HighestCounterNote()
        {
            var sortedNotes = NItems.OrderByDescending(o => o.EventTime).Where(o => o.Counter > 0).ToList();
            if (sortedNotes.Count == 0) return null;

            return sortedNotes.First();
        }
        internal double calcCounterEstimate()
        {
            var calculated = calculateIncreaseInDay();

            return calculated.estimateNow;
        }

        private (double increaseInDay, double estimateNow) calculateIncreaseInDay()
        {
            if (NItems.Count < 1) { return (increaseInDay: 0.0 , estimateNow: 0.0 ); }
            var sortedNotes = NItems.OrderByDescending(o => o.EventTime).Where(o => o.Counter > 0).ToList();

            if (sortedNotes.Count < 1) { return (increaseInDay: 0.0, estimateNow: 0.0); }

            var highestCounter = sortedNotes.First().Counter;
            List<double> increaseInDate = new List<double>();

            int i = -1;
            foreach (var note in sortedNotes)
            {
                i++;
                if (i < 1) continue;

                var prev = sortedNotes.ElementAt(i - 1);

                double dates = (prev.EventTime - note.EventTime).TotalDays;

                int couter = prev.Counter - note.Counter;

                increaseInDate.Add(couter / dates);
            }
            // cannot calculate estimation
            if (increaseInDate.Count < 1)
            {
                CounterEstimate = "";
                return (increaseInDay: -1, estimateNow: -1);
            }
            // mediaani
            //var increaseInDateArray = increaseInDate.OrderBy(d => d).ToArray();
            //var increaseInD = increaseInDateArray[increaseInDateArray.Length / 2];

            // pitäisi painottaa viimeisen vuoden lukemia?
            double increaseInDay = increaseInDate.Sum(d => d) / increaseInDate.Count;

            double datesToNow = (DateTime.Now - sortedNotes.First().EventTime).TotalDays;

            double estimateNow = (datesToNow < 1) ? highestCounter : highestCounter + increaseInDay * datesToNow;


            return (increaseInDay: increaseInDay, estimateNow: estimateNow);
        }
        public void Refresh()
        {
            foreach (var note in this.NItems)
            {
                note.Dependant = this;
                note.SetOutputText();
                note.AddToItems();
            }
            foreach (var scheduler in this.SItems)
            {
                scheduler.Dependant = this;
                scheduler.GenerateNote();
                scheduler.SetListText();
            }

            CalculateCounterEstimate();
        }
    }
}
