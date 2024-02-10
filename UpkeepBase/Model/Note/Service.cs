using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model.Note
{
    internal class Service : Note, INoteService
    {
        private const string CLASSTITLE = "Huolto";

        public double Price { get; set; }

        public string Fixer { get; set; }

        public override void SetOutputText()
        {
            var eventtime = getEventTimeForOutput();
            var ownerName = (Dependant != null) ? " " + Dependant.Name : "";

            ListText = eventtime + " " + Title + " " + Description;
            ListTextAllNotes = eventtime + ownerName + " " + Title + " " + Description;
        }

        public Service() : base(CLASSTITLE)
        {
        }
        public Service(string title, string description = "") : base(title, description)
        {
        }
        public Service(string title, string description, DateTime eventTime) : base(title, description, eventTime)
        {
        }
    }
}
