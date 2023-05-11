using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;

namespace UpkeepBase.Forms.Model.Scheduler
{
    public interface IScheduler
    {
        string Title { get; set; }
        string Description { get; set; }

        NoteTypes NoteType { get; set; }

        DateTime StartTime { get; set; }

        // Schedulre rules
        bool Annual { get; set; }
        bool Biannual { get; set; }
        bool Quaterly { get; set; }

        // custom scheduler rules
        int CustomPeriodMonths { get; set; }

        // counter rules
        int CounterValue { get; set; }
        int StartCounterValue { get; set; }
        DateTime NextScheduleTime { get; }
        string ListText { get; }
        IDependant Dependant { get; set; }
        void SetListText();
        void GenerateNote();

    }
}
