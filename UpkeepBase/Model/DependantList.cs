using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model
{
    public class DependantList : List<IDependant>
    {
        public string DLName { get; set; }
        public DependantList(string name) { this.DLName = name; }


        public DependantList()
        {
        }

        public List<IDependant> Items { get { return this.OrderBy(dep => dep.Name).OrderBy(dep => dep.TagsString).ToList(); } }

        public void Refresh()
        {
            this.Items.ForEach(dep => dep.Refresh());
        }

    }
}
