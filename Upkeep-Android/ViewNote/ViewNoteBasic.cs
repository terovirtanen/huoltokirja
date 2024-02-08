﻿using Android.App;
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
using static Upkeep_Android.ViewDependantList;
using UpkeepBase.Model.Note;

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

            if (mNote.GetType().Name == "Service" || mNote.GetType().Name == "Inspection")
            {
                var _view = inflater.Inflate(Resource.Layout.view_note_service, null);
                ElementSetService(_view);
                parentLayout.AddView(_view);
            }


            ElementSet(view);

            var elementDate = view.FindViewById<TextView>(Resource.Id.noteDate);
            //var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.noteDate);
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
            var elementType = view.FindViewById<Spinner>(Resource.Id.noteTypeSpinner);

            var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, Constansts.NoteTypes);
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            elementType.Adapter = adapter;

            if (mNote != null)
            {
                elementTitle.Text = mNote.Title;
                elementDescription.Text = mNote.Description;

                var index = 2;
                if (mNote.GetType().Name == "Service") { index = 1; }
                if (mNote.GetType().Name == "Inspection") { index = 0; }

                elementType.SetSelection(index);


            }

        }
        private void ElementSetService(View view)
        {
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
            var elementType = view.FindViewById<Spinner>(Resource.Id.noteTypeSpinner);


            if (mNote != null)
            {
                mNote.Title = elementTitle.Text;
                mNote.Description = elementDescription.Text;
            }
        }

        public void OnDialogClose()
        {
            ElementSave(View);
        }
    }
}