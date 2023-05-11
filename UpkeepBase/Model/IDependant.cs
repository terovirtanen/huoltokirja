using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Forms.Model.Scheduler;
using UpkeepBase.Model.Note;

namespace UpkeepBase.Model
{
    public interface IDependant
    {
        string Name { get; }
        string TagsString { get; }
        string CounterEstimate { get; }
        string CounterUnit { get; set; }

        List<INote> NItems { get; }
        List<IScheduler> SItems { get; }
        List<INote> NItemsOrderByDescendingByEventTime { get; }
        List<IScheduler> SItemsOrderByByEventTime { get; }


        void Refresh();

        INote AddNote(string title, string description = "");
        INote AddService(string title,
           string description = "",
           string fixer = "",
           double price = 0.0,
           int counter = 0);
        INote AddInspection(bool pass, string description = "");

        INote AddNoteFromScheduler(NoteTypes noteType, string title, string description, DateTime eventtime);
        void RemoveNote(INote note);
        void AddScheduler(IScheduler scheduler);
        void RemoveScheduler(IScheduler scheduler);
        void CalculateCounterEstimate();
        double CounterIncreaseInDay();
        INote HighestCounterNote();

    }
}
