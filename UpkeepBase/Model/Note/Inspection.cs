using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model.Note
{
    internal class Inspection : Service, INoteInspection
    {
        private const string CLASSTITLE = "Katsastus";
        public bool Pass { get; set; }

        public override void SetOutputText()
        {
            var eventtime = getEventTimeForOutput();

            string passtext = Pass ? "Hyväksytty" : "Hylätty";
            ListText = eventtime + " " + Title + passtext + " " + Description;

            var ownerName = (Dependant != null) ? " " + Dependant.Name : "";
            ListTextAllNotes = eventtime + " " + ownerName + " " + Title + " " + Description;
        }
        public Inspection() : base(CLASSTITLE)
        {

        }
        public Inspection(bool pass = false, string description = "") : base(CLASSTITLE, description)
        {
            Pass = pass;

            SetOutputText();
        }
        public Inspection(bool pass, string description, DateTime eventTime) : base(CLASSTITLE, description, eventTime)
        {
            Pass = pass;

            SetOutputText();
        }
    }
}
