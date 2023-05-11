using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;

namespace UpkeepBase.Forms.Model.Scheduler
{
    internal class Scheduler : IScheduler
    {
        public string Title { get; set; }
        public string Description { get; set; }

        public NoteTypes NoteType { get; set; }

        public DateTime StartTime { get; set; }

        // Scheduler rules
        public bool Annual { get; set; }
        public bool Biannual { get; set; }
        public bool Quaterly { get; set; }

        // custom scheduler rules
        public int CustomPeriodMonths { get; set; }

        // counter rules
        public int CounterValue { get; set; }
        public int StartCounterValue { get; set; }

        // edellinen aika jolloin luotu ajastettu note
        public DateTime PreviousScheduledTime { get; set; }
        // next time when schedule note
        // this is calculated value
        [JsonIgnore]
        public DateTime NextScheduleTime { get; set; }


        [JsonIgnore]
        public string ListText { get; protected set; }

        [JsonIgnore]
        private int generateOfftimeInMonths = 3;

        [JsonIgnore]
        public IDependant Dependant { get; set; }
        public Scheduler()
        {
        }

        public void SetListText()
        {
            calculateNextScheduleTime();
            var emptyDate = new DateTime();

            string nextScheduleTime = (NextScheduleTime != emptyDate) ? ", arvio " + NextScheduleTime.ToString("dd.MM.yyyy") : "";

            ListText = Title + nextScheduleTime;
        }
        public void GenerateNote()
        {
            generateNote();
        }
        internal void generateNote()
        {
            do
            {
                calculateNextScheduleTime();

                if (NextScheduleTime.Date > PreviousScheduledTime.Date &&
                    NextScheduleTime < DateTime.Now.AddMonths(generateOfftimeInMonths))
                {
                    triggerNote();
                }
            } while (NextScheduleTime.Date > PreviousScheduledTime.Date &&
                     NextScheduleTime < DateTime.Now.AddMonths(generateOfftimeInMonths));

        }

        private void triggerNote()
        {
            Dependant.AddNoteFromScheduler(NoteType, Title, Description, NextScheduleTime);
            PreviousScheduledTime = NextScheduleTime;
        }

        internal void calculateNextScheduleTime()
        {
            var emptyDate = new DateTime();

            if (PreviousScheduledTime == null || PreviousScheduledTime == emptyDate) PreviousScheduledTime = StartTime;

            List<DateTime> nextDates = new List<DateTime> { };

            getNextDateAnnual(nextDates);
            getNextDateBiannual(nextDates);
            getNextDateQuaterly(nextDates);
            getNextDateCustomPeriodMonths(nextDates);
            getNextDateCounterValue(nextDates);

            if (nextDates.Count < 1) nextDates.Add(PreviousScheduledTime);

            nextDates.Sort((a, b) => a.CompareTo(b));
            NextScheduleTime = nextDates.First();
        }

        private DateTime getNextDateAnnual(List<DateTime> nextDates)
        {
            if (!Annual) return PreviousScheduledTime;

            DateTime newTime = PreviousScheduledTime;
            // Ei generoida menneisyyteen
            while (newTime < DateTime.Now)
            {
                newTime = newTime.AddYears(1);
            }
            nextDates.Add(newTime);
            return newTime;
        }
        private DateTime getNextDateBiannual(List<DateTime> nextDates)
        {
            if (!Biannual) return PreviousScheduledTime;

            DateTime newTime = PreviousScheduledTime;
            // Ei generoida menneisyyteen
            while (newTime < DateTime.Now)
            {
                newTime = newTime.AddMonths(6);
            }
            nextDates.Add(newTime);
            return newTime;
        }
        private DateTime getNextDateQuaterly(List<DateTime> nextDates)
        {
            if (!Quaterly) return PreviousScheduledTime;

            DateTime newTime = PreviousScheduledTime;
            // Ei generoida menneisyyteen
            while (newTime < DateTime.Now)
            {
                newTime = newTime.AddMonths(3);
            }
            nextDates.Add(newTime);
            return newTime;
        }
        private DateTime getNextDateCustomPeriodMonths(List<DateTime> nextDates)
        {
            if (CustomPeriodMonths < 1) return PreviousScheduledTime;

            DateTime newTime = PreviousScheduledTime;
            // Ei generoida menneisyyteen
            while (newTime < DateTime.Now)
            {
                newTime = newTime.AddMonths(CustomPeriodMonths);
            }
            nextDates.Add(newTime);
            return newTime;
        }
        private DateTime getNextDateCounterValue(List<DateTime> nextDates)
        {
            if (CounterValue < 1 || StartCounterValue < 1) return PreviousScheduledTime;

            double increaseInDay = Dependant.CounterIncreaseInDay();
            if (increaseInDay <= 0) return PreviousScheduledTime;

            INote highestCounterNote = Dependant.HighestCounterNote();
            if (highestCounterNote == null) return PreviousScheduledTime;

            DateTime newTime = PreviousScheduledTime;
            // viimeisin merkintä on uudempi, käytetään sen arvoja
            if (PreviousScheduledTime < highestCounterNote.EventTime && StartCounterValue < highestCounterNote.Counter)
            {
                // viimeisestä merkinnästä jäänyt jäljelle
                int counterToNextEvent = CounterValue - ((highestCounterNote.Counter - StartCounterValue) % CounterValue);

                newTime = highestCounterNote.EventTime.AddDays(counterToNextEvent / increaseInDay);
            }

            double daysInCounterPeriod = CounterValue / increaseInDay;

            // Ei generoida menneisyyteen
            while (newTime < DateTime.Now)
            {
                newTime = newTime.AddDays(daysInCounterPeriod);
            }

            nextDates.Add(newTime);
            return newTime;
        }
    }
}
