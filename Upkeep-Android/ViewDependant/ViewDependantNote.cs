using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.Fragment.App;
using AndroidX.RecyclerView.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UpkeepBase.Data;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using Fragment = AndroidX.Fragment.App.Fragment;

namespace Upkeep_Android
{
    public class ViewDependantNote : Fragment, IOnDialogCloseListener
    {
        private static Dependant mDependant;
        public ViewDependantNote() : base()
        {

        }
        public static ViewDependantNote NewInstance(IDependant dependant)
        {
            mDependant = dependant as Dependant;
            return new ViewDependantNote { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_note, container, false);

            RefresfListViewData(view);

            return view;
        }

        public void OnDialogClose()
        {
            //throw new NotImplementedException();
        }
        private void RefresfListViewData(View _view)
        {
            var notesList = mDependant.NItemsOrderByDescendingByEventTime;
            List<NotesListItems> objstud = ConvertToNotesList(notesList);

            var mlist = new List<NotesListItems>();
            mlist = objstud;
            var noteslistadapter = new DependantNotesListAdapter(this.Context as Activity, mlist);

            var dependantNotesList = (ListView)_view.FindViewById<ListView>(Resource.Id.listDependantNotes);
            dependantNotesList.Adapter = noteslistadapter;

            dependantNotesList.ItemClick += (s, e) =>
            {
                var t = noteslistadapter[e.Position];
                Toast.MakeText(this.Context, t.Title, ToastLength.Long).Show();

                //var fm = _fragmentManager;
                //var dialog = MainDialogFragment.NewInstance(this.Context);
                //dialog.Show(fm, "dialog");
            };
        }
        private List<NotesListItems> ConvertToNotesList(List<INote> notesList)
        {
            List<NotesListItems> noteslist = new List<NotesListItems>();

            notesList.ForEach(item =>
            {
                noteslist.Add(new NotesListItems
                {
                    Title = item.Title,
                    Description = item.ListText
                });
            });

            return noteslist;
        }

    }
}