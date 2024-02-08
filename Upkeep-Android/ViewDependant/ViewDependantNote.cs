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

                var note = mDependant.NItemsOrderByDescendingByEventTime.Find(x => x.GetHashCode() == t.ItemHashCode);

                NoteActivity.mNote = (INote)note;

                Intent intent = new Intent(this.Context, typeof(NoteActivity));
                intent.PutExtra("noteHashCode", t.ItemHashCode);
                StartActivity(intent);

                //Spinner spinner = _view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
                //string selected = spinner.SelectedItem.ToString();

                //IDependant dependant = dataManager.GetDependantList().Items.Find(x => x.Name == selected);

                //Intent intent = new Intent(this.Context, typeof(DependantActivity));
                //intent.PutExtra("selectedDependantName", dependant.Name);
                //StartActivity(intent);

            };
        }
        private List<NotesListItems> ConvertToNotesList(List<INote> notesList)
        {
            List<NotesListItems> _noteslist = new List<NotesListItems>();

            notesList.ForEach(item =>
            {
                _noteslist.Add(new NotesListItems
                {
                    Title = item.Title,
                    Description = item.ListText,
                    ItemHashCode = item.GetHashCode()
                });
            });

            return _noteslist;
        }

    }
}