using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model.Note;

namespace UpkeepBase.Model
{
    public class NotesList : List<INote>
    {
        public NotesList()
        {
            
        }
        public List<INote> Items { get { return (Note.Note.Items != null) ? Note.Note.Items.OrderByDescending(note => note.EventTime).ToList() : new List<INote>(); } }        
    }
}
