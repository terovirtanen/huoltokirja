using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model;

namespace UpkeepBase.Data
{
    internal class TestData
    {
        public void AddTestData(DependantList depandantList)
        {
            AddTestDataCar(depandantList);
            AddTestDataHouse(depandantList);

        }
        private void AddTestDataHouse(DependantList depandantList)
        {
            var iv = new Dependant("Ilmastointikone", "talo", DateTime.Now);
            var pi = new Dependant("Pölynimuri", "talo", DateTime.Now);

            iv.AddNote("Suodattimet", "Hienosuodattimet");
            iv.AddNote("Suodattimien vaihto", "Kaikki suodattimet");

            pi.AddNote("Pölypussi");

            depandantList.Add(iv);
            depandantList.Add(pi);
        }
        private void AddTestDataCar(DependantList depandantList)
        {
            var car1 = new Dependant("Audi", "autot", DateTime.Now);
            var car2 = new Dependant("Skoda", "autot", DateTime.Now);

            car1.AddService("Pyyhkijän sulka", "", "Itse", 23.53, 12345);
            car1.AddService("Öljynvaihto", "50w-30", "SEO", 123, 12456);
            car2.AddService("Öljynvaihto");
            car2.AddInspection(true, "Läpi meni!");
            car2.AddInspection(false, "Korjattavaa");

            depandantList.Add(car1);
            depandantList.Add(car2);
        }
    }
}
