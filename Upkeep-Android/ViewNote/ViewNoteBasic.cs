using Android.App;
using AndroidX.Fragment.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Fragment = AndroidX.Fragment.App.Fragment;
using UpkeepBase.Model;
using static Android.InputMethodServices.Keyboard;
using AndroidX.AppCompat.Widget;
using System.Runtime.InteropServices;
using UpkeepBase.Model.Note;
using Java.Lang.Annotation;

namespace Upkeep_Android
{

    public class ViewNoteBasic : Fragment, IOnDialogCloseListener
    {
        private static INote mNote;

        TextView _dateDisplay;

        public ViewNoteBasic() : base()
        {

        }
        public static ViewNoteBasic NewInstance(INote note)
        {
            mNote = note as INote;
            return new ViewNoteBasic { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_note, container, false);

            LinearLayout parentLayout = view.FindViewById<LinearLayout>(Resource.Id.noteParentLinearLayout);

            if ( mNote.GetType().Name == "Inspection")
            {
                var _view = inflater.Inflate(Resource.Layout.view_note_inspection, null);
                ElementSetInspection(_view);
                parentLayout.AddView(_view);
            }

            if (mNote.GetType().Name == "Service" || mNote.GetType().Name == "Inspection")
            {
                var _view = inflater.Inflate(Resource.Layout.view_note_service, null);
                ElementSetService(_view);
                parentLayout.AddView(_view);
            }


            ElementSet(view);

            //var elementDate = view.FindViewById<TextView>(Resource.Id.noteDate);
            var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.noteDate);
            elementDate.Text = mNote.EventTime.ToShortDateString();

            elementDate.Click += (s, e) =>
            {
                var elementDate = view.FindViewById<TextView>(Resource.Id.noteDate);
                DatePickerFragment frag = DatePickerFragment.NewInstance(delegate (DateTime time)
                {
                    elementDate.Text = time.ToShortDateString();
                });
                frag.Show(this.ChildFragmentManager, DatePickerFragment.TAG);
            };

            return view;
        }


        public override void OnDestroyView()
        {
            ElementSave(View);

            base.OnDestroyView();
        }

        private void ElementSet(View view)
        {
            var elementTitle = view.FindViewById<AppCompatEditText>(Resource.Id.noteTitle);
            var elementDescription = view.FindViewById<AppCompatEditText>(Resource.Id.noteDescription);
            //var elementType = view.FindViewById<Spinner>(Resource.Id.noteTypeSpinner);

            //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, Constansts.NoteTypes);
            //adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            //elementType.Adapter = adapter;

            if (mNote != null)
            {
                elementTitle.Text = mNote.Title;
                elementDescription.Text = mNote.Description;

                //var index = 2;
                //if (mNote.GetType().Name == "Service") { index = 1; }
                //if (mNote.GetType().Name == "Inspection") { index = 0; }

                //elementType.SetSelection(index);
            }
        }
        private void ElementSetService(View view)
        {
            var elementCounter = view.FindViewById<AppCompatEditText>(Resource.Id.noteCounter);
            var elementPrice = view.FindViewById<AppCompatEditText>(Resource.Id.notePrice);
            var elementFixer = view.FindViewById<AppCompatEditText>(Resource.Id.noteFixer);
            if (mNote != null)
            {
                elementCounter.Text = mNote.Counter.ToString();
                elementPrice.Text = (mNote as INoteService).Price.ToString();
                elementFixer.Text = (mNote as INoteService).Fixer;
            }
        }
        private void ElementSetInspection(View view)
        {
            var elementInspection = view.FindViewById<CheckBox>(Resource.Id.checkBoxInspection);
            if (mNote != null)
            {
                elementInspection.Checked = (mNote as INoteInspection).Pass;
            }
        }
        void DateSelect_OnClick(object sender, EventArgs eventArgs)
        {
            DatePickerFragment frag = DatePickerFragment.NewInstance(delegate (DateTime time)
            {
                _dateDisplay.Text = time.ToLongDateString();
            });
            frag.Show(FragmentManager, DatePickerFragment.TAG);
        }
        //spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
        //    spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
        //    //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //    var adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
        //    spinner.Adapter = adapter;
        private void ElementSave(View view)
        {
            var elementTitle = view.FindViewById<AppCompatEditText>(Resource.Id.noteTitle);
            var elementDescription = view.FindViewById<AppCompatEditText>(Resource.Id.noteDescription);
            var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.noteDate);

            if (mNote != null)
            {
                mNote.Title = elementTitle.Text;
                mNote.Description = elementDescription.Text;
                mNote.EventTime = DateTime.Parse(elementDate.Text);

                if (mNote.GetType().Name == "Service" || mNote.GetType().Name == "Inspection")
                {
                    INoteService noteService = mNote as INoteService;
                    noteService.Counter = Convert.ToInt32(view.FindViewById<AppCompatEditText>(Resource.Id.noteCounter).Text);
                    noteService.Price = Convert.ToDouble(view.FindViewById<AppCompatEditText>(Resource.Id.notePrice).Text);
                    noteService.Fixer = view.FindViewById<AppCompatEditText>(Resource.Id.noteFixer).Text;
                }
                if (mNote.GetType().Name == "Inspection")
                {
                    INoteInspection noteInspection = mNote as INoteInspection;
                    noteInspection.Pass = view.FindViewById<AppCompatCheckBox>(Resource.Id.checkBoxInspection).Checked;
                }
            }
        }

        public void OnDialogClose()
        {
            ElementSave(View);
        }
    }
}