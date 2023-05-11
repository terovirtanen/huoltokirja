using System.Xml.Linq;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;

namespace UpkeepBaseTest
{
    [TestClass]
    public class ModelDependantUnitTest
    {
        [TestMethod]
        public void DependantCounterEstimateSimpleTest()
        {

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

            var estimate = dependant.calcCounterEstimate();

            Assert.AreEqual(20000, Math.Floor(estimate));
        }

        [TestMethod]
        public void DependantCounterEstimateSimple2Test()
        {

            var dependant = new Dependant
            {
                Name = "Test",
                CounterUnit = "km"
            };

            var note1 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-70),
                Counter = 10000
            };
            var note2 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-30),
                Counter = 15000
            };
            var note3 = new Service
            {
                Dependant = dependant,
                EventTime = DateTime.Now.AddDays(-10),
                Counter = 20000
            };
            dependant.NItems.Add(note1);
            dependant.NItems.Add(note2);
            dependant.NItems.Add(note3);

            var estimate = dependant.calcCounterEstimate();

            Assert.AreEqual(21875, Math.Floor(estimate));
        }
        [TestMethod]
        public void DependantCounterIncreaseInDayTest()
        {

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

            var increaseInDay = dependant.CounterIncreaseInDay();

            Assert.AreEqual(166, Math.Floor(increaseInDay));
        }

        [TestMethod]
        public void DependantAddNoteFromScheduler()
        {
            var dependant = new Dependant
            {
                Name = "Test",
                CounterUnit = "km"
            };
            var newdate = DateTime.Now;
            INote note = dependant.AddNoteFromScheduler(NoteTypes.BASIC, "Title", "Kuvaus", newdate);

            Assert.AreEqual(note.Title, "Title");
            Assert.AreEqual(note.Description, "Kuvaus");
            Assert.AreEqual(note.EventTime, newdate);

        }
    }
}