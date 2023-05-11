using UpkeepBase.Forms.Model.Scheduler;
using UpkeepBase.Model.Note;
using UpkeepBase.Model;

namespace UpkeepBaseTest
{
    [TestClass]
    public class ModelSchedulerUnitTest
    {
        [TestMethod]
        public void ScheduleAnnualTest()
        {

            int fixedYear = DateTime.Now.Year;

            var scheduler = new Scheduler
            {
                Title = "Test",
                StartTime = new DateTime(fixedYear, 1, 1),
                Annual = true
            };

            Assert.AreEqual(scheduler.Title, "Test");
            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(new DateTime(fixedYear + 1, 1, 1), scheduler.NextScheduleTime);
        }
        [TestMethod]
        public void ScheduleBiannualTest()
        {

            int year = DateTime.Now.Year;
            int month = DateTime.Now.Month;

            DateTime refDate = new DateTime(year, month, 1);

            var scheduler = new Scheduler
            {
                StartTime = refDate,
                Biannual = true
            };

            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(refDate.AddMonths(6), scheduler.NextScheduleTime);
        }
        [TestMethod]
        public void ScheduleQuaterlyTest()
        {

            int year = DateTime.Now.Year;
            int month = DateTime.Now.Month;

            DateTime refDate = new DateTime(year, month, 1);

            var scheduler = new Scheduler
            {
                StartTime = refDate,
                Quaterly = true
            };

            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(refDate.AddMonths(3), scheduler.NextScheduleTime);
        }
        [TestMethod]
        public void ScheduleCustomPeriodMonthsOneTest()
        {

            int year = DateTime.Now.Year;
            int month = DateTime.Now.Month;

            DateTime refDate = new DateTime(year, month, 1);

            var scheduler = new Scheduler
            {
                StartTime = refDate,
                CustomPeriodMonths = 1
            };

            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(refDate.AddMonths(1), scheduler.NextScheduleTime);
        }
        [TestMethod]
        public void ScheduleCounterValueSimpleTest()
        {
            // initial dependant 
            var dependant = new Dependant
            {
                Name = "Test",
                CounterUnit = "km"
            };

            var note1 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-60),
                Counter = 10000
            };
            var note2 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-30),
                Counter = 15000
            };

            dependant.NItems.Add(note1);
            dependant.NItems.Add(note2);

            // initial scheduler 
            var scheduler = new Scheduler
            {
                Dependant = dependant,
                StartTime = DateTime.Now.AddDays(-90),
                CounterValue = 10000,
                StartCounterValue = 5000,
            };

            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(DateTime.Now.AddDays(30).Date, scheduler.NextScheduleTime.Date);
        }
        [TestMethod]
        public void ScheduleCounterValueSimple2Test()
        {
            // initial dependant 
            var dependant = new Dependant
            {
                Name = "Test",
                CounterUnit = "km"
            };

            var note1 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-20),
                Counter = 100
            };
            var note2 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-10),
                Counter = 111
            };

            dependant.NItems.Add(note1);
            dependant.NItems.Add(note2);

            // initial scheduler 
            var scheduler = new Scheduler
            {
                Dependant = dependant,
                StartTime = DateTime.Now.AddDays(-5),
                CounterValue = 2,
                StartCounterValue = 112,
            };

            scheduler.calculateNextScheduleTime();

            Assert.AreEqual(DateTime.Now.AddDays(1).Date, scheduler.NextScheduleTime.Date);
        }
        [TestMethod]
        public void ScheduleGenerateNoteTest()
        {
            // initial dependant 
            var dependant = new Dependant
            {
                Name = "Test",
                CounterUnit = "km"
            };

            var note1 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-20),
                Counter = 100,
                Status = NoteStatus.UPDATED,
            };
            var note2 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-10),
                Counter = 111,
                Status = NoteStatus.UPDATED,
            };

            dependant.NItems.Add(note1);
            dependant.NItems.Add(note2);

            // initial scheduler 
            var scheduler = new Scheduler
            {
                Dependant = dependant,
                StartTime = DateTime.Now.AddDays(-5),
                CounterValue = 2,
                StartCounterValue = 112,
                Title = "Scheduled note",
                NoteType = NoteTypes.BASIC,
            };

            scheduler.GenerateNote();

            Assert.AreEqual(dependant.NItems.Count, 3);

            var scheduledNote = dependant.NItems.Last();

            Assert.AreEqual("Scheduled note", scheduledNote.Title);
            Assert.AreEqual(DateTime.Now.AddDays(1).Date, scheduledNote.EventTime.Date);
        }
    }
}