using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace UpkeepBase.Model.Note
{
    public interface INoteService : INote
    {
        double Price { get; set; }

        string Fixer { get; set; }

    }
}
