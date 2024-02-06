using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model;

namespace UpkeepBase.Data
{
    public class DataManager
    {
        private static DataManager dataManager = new DataManager();
        private DependantList dependantlist;

        private DataManager()
        {
            dependantlist = new DependantList();

            TestData testData = new TestData();
            testData.AddTestData(dependantlist);
        }
        public static DataManager GetInstance()
        {
            if (dataManager == null)
            {
                dataManager = new DataManager();
            }
            return dataManager;
        }

        public DependantList GetDependantList()
        {
            return dependantlist;
        }
    }
}
