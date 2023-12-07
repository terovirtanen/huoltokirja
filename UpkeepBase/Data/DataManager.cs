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
        private DependantList dependantlist = new DependantList();

        public DataManager()
        {
            TestData testData = new TestData();
            testData.AddTestData(this.dependantlist);
        }

        public DependantList GetDependantList()
        {
            return dependantlist;
        }
    }
}
