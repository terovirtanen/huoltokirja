using Android.Content;
using Android.Views;
using Android.Widget;
using AndroidX.Core.App;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using static Upkeep_Android.ViewDependantList;
using UpkeepBase.Data;
using DialogFragment = AndroidX.Fragment.App.DialogFragment;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using static Android.Provider.ContactsContract.CommonDataKinds;
using AndroidX.AppCompat.Widget;
using Upkeep_Android.Utils;

namespace Upkeep_Android
{
    public class DialogNoteAddSelector : DialogFragment
    {
        static Context mContext;
        private string mSelectedDependant;

        public static DialogNoteAddSelector NewInstance(Context context)
        {
            mContext = context;
            return new DialogNoteAddSelector();
        }
        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        { 
            var view = inflater.Inflate(Resource.Layout.dialog_note_add_selector, container, false);

            SpinnerData(view);

            var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.noteAddDate);
            elementDate.Text = DateTime.Now.ToString();

            elementDate.Click += (s, e) =>
            {
                var elementDate = view.FindViewById<TextView>(Resource.Id.noteAddDate);
                DatePickerFragment frag = DatePickerFragment.NewInstance(delegate (DateTime time)
                {
                    elementDate.Text = time.ToShortDateString();
                });
                frag.Show(this.ChildFragmentManager, DatePickerFragment.TAG);
            };

            var btnAddNew = view.FindViewById<Button>(Resource.Id.noteSelectorAddButton);
            btnAddNew.Click += BtnAddNew_ClickAsync;

            var btnCancel = view.FindViewById<Button>(Resource.Id.noteSelectorCancelButton);
            btnCancel.Click += BtnCancel_Click;

            return view;
        }
        private void BtnAddNew_ClickAsync(object sender, EventArgs e)
        {
            Spinner spinner = this.View?.FindViewById<Spinner>(Resource.Id.noteSelectorDependantSpinner);
            string selectedDependant = spinner.SelectedItem?.ToString();

            string title = this.View?.FindViewById<AppCompatEditText>(Resource.Id.noteAddTitle)?.Text;

            var elementDate = this.View?.FindViewById<AppCompatEditText>(Resource.Id.noteAddDate);

            if (title == "")
            {
                AlertHelper.AlertAsync(mContext, "Alert", "Title cannot be empty", "OK");
                return;
            }

            IDependant dependant = ((mContext as Activity).Application as UpKeepApplication).dataManager.GetDependantList().Items.Find(x => x.Name == selectedDependant);

            RadioGroup radioGroup = this.View?.FindViewById<RadioGroup>(Resource.Id.noteSelectorTypesRadioGroup);
            var selectedRadioId = radioGroup.CheckedRadioButtonId;
            Boolean pass = false;
            INote note;
            if (selectedRadioId == Resource.Id.noteSelectorServiceRadioButton) {
                note = dependant.AddService(title);
            }
            else if (selectedRadioId == Resource.Id.noteSelectorInspectionRadioButton) {
                note = dependant.AddInspection(pass);
            }
            else {
                note = dependant.AddNote(title);
            }
            note.EventTime = DateTime.Parse(elementDate.Text);

            NoteActivity.mNote = note;
            Intent intent = new Intent(this.Context, typeof(NoteActivity));
            //StartActivity(intent);

            var activity = mContext as ActivityBase;
            activity._requestCode = 1001;  //flag to handle the multiple intent request 
            activity._note = note;
            activity._activityResultLauncher.Launch(intent);


            // note activity aloitettu, suljetaan tämä dialog
            Dismiss();
        }
        private void BtnCancel_Click(object sender, EventArgs e)
        {
            Dismiss();
        }

        private void SpinnerData(View view)
        {
            var dataManager = ((mContext as Activity).Application as UpKeepApplication).dataManager;

            var dependants = dataManager.GetDependantList().Items.Select(x => x.Name).ToList();

            var spinner = view.FindViewById<Spinner>(Resource.Id.noteSelectorDependantSpinner);
            spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
            //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
            var adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            spinner.Adapter = adapter;
        }
        private void spinner_ItemSelected(object sender, AdapterView.ItemSelectedEventArgs e)
        {
            Spinner spinner = (Spinner)sender;
            var selected = spinner.GetItemAtPosition(e.Position);
            mSelectedDependant = selected?.ToString();
        }
    }
}