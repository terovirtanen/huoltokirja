using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model.Note
{
    public enum NoteTypes { INSPECTION, SERVICE, BASIC }
    public enum NoteStatus { SCHEDULED, UPDATED }

    public interface INote
    {
        string Title { get; set; }

        string Description { get; set; }
        DateTime EventTime { get; set; }

        string ListText { get; }
        string ListTextAllNotes { get; }
        
        int Counter { get; set; }
        NoteStatus Status { get; set; }
        IDependant Dependant { get; set; }

        void SetOutputText();
        void AddToItems();
        void RemoveFromItems();
        Color ListColor();

    }
}
