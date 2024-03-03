using Android.App;
using Android.Content;
using Android.Media.TV;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.RecyclerView.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UpkeepBase.Data;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using static Java.IO.ObjectInputStream;
using Fragment = AndroidX.Fragment.App.Fragment;
using AndroidX.Fragment.App;
using System.Runtime.CompilerServices;
using Android.Webkit;

namespace Upkeep_Android
{
    public class ViewDependantList : Fragment, IOnDialogCloseListener
    {
        private DataManager dataManager;
        private Spinner spinner;

        private DependantListAdapter mDependantListAdapter;
        private IDependant mDependantItem;

        protected static AndroidX.Fragment.App.FragmentManager _fragmentManager;
        public static ViewDependantList NewInstance(AndroidX.Fragment.App.FragmentManager fragmentManager)
        {
            _fragmentManager = fragmentManager;
            return new ViewDependantList { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_list_dependant, container, false);

            dataManager = ((this.Context as Activity).Application as UpKeepApplication).dataManager;

            var dependants = dataManager.GetDependantList().Items.Select(x => x.Name).ToList();

            spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
            spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
            //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
            var adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            spinner.Adapter = adapter;


            RefresfListViewData(view, dependants.FirstOrDefault());

            var dependantButton = (Button)view.FindViewById<Button>(Resource.Id.buttonAddDependant);

            dependantButton.Click += (s, e) =>
            {
                //var t = "Add new";
                //Toast.MakeText(this.Context, t, ToastLength.Long).Show();

                Spinner spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
                string selected = spinner.SelectedItem.ToString();

                IDependant dependant = dataManager.GetDependantList().Items.Find(x => x.Name == selected);

                //var fm = _fragmentManager;
                //var dialog = MainDialogFragment.NewInstance(this.Context, dependant, this);
                //dialog.Show(fm, "dialog");


                Intent intent = new Intent(this.Context, typeof(DependantActivity));
                intent.PutExtra("selectedDependantName", dependant.Name);
                StartActivity(intent);
            };

            var dependantList = (ListView)view.FindViewById<ListView>(Resource.Id.dependantlistview);
            //dependantList.Adapter = mDependantListAdapter;

            dependantList.ItemClick += (s, e) =>
            {                
                var t = mDependantListAdapter[e.Position];
                //Toast.MakeText(this.Context, t.Title, ToastLength.Long).Show();

                //Intent intent = new Intent(this.Context, typeof(DependantActivity));
                //StartActivity(intent);
                var note = mDependantItem.NItemsOrderByDescendingByEventTime.Find(x => x.GetHashCode() == t.ItemHashCode);

                NoteActivity.mNote = (INote)note;

                Intent intent = new Intent(this.Context, typeof(NoteActivity));
                intent.PutExtra("noteHashCode", t.ItemHashCode);
                StartActivity(intent);
            };

            return view;
        }

        private void spinner_ItemSelected(object sender, AdapterView.ItemSelectedEventArgs e)
        {
            Spinner spinner = (Spinner)sender;
            var selected = spinner.GetItemAtPosition(e.Position);
            string toast = string.Format("The dependant is {0}", selected);

            RefresfListViewData(this.View, selected.ToString());

            Toast.MakeText(this.Context as Activity, toast, ToastLength.Long).Show();
        }

        private void RefresfListViewData(View _view, string dependantName)
        {
            mDependantItem = dataManager.GetDependantList().Items.Where(x => x.Name == dependantName).First();

            TextView textfield = _view.FindViewById<TextView>(Resource.Id.dependantText);

            // show text field only if something to present
            mDependantItem.CalculateCounterEstimate();
            textfield.Text = mDependantItem.CounterEstimate;
            //textfield.Visibility = (textfield.Text == "") ? ViewStates.Gone : ViewStates.Visible;

            var notesList = mDependantItem.NItemsOrderByDescendingByEventTime;
            List<DependantListItems> objstud = ConvertToDependantList(notesList);

            var mlist = new List<DependantListItems>();
            mlist = objstud;
            mDependantListAdapter = new DependantListAdapter(this.Context as Activity, mlist);

            var dependantList = (ListView)_view.FindViewById<ListView>(Resource.Id.dependantlistview);
            dependantList.Adapter = mDependantListAdapter;

            //dependantList.ItemClick += (s, e) =>
            //{
                
            //    var t = dependantlistadapter[e.Position];
            //    Toast.MakeText(this.Context, t.Title, ToastLength.Long).Show();

            //    //Intent intent = new Intent(this.Context, typeof(DependantActivity));
            //    //StartActivity(intent);
            //    var note = dependantItem.NItemsOrderByDescendingByEventTime.Find(x => x.GetHashCode() == t.ItemHashCode);

            //    NoteActivity.mNote = (INote)note;

            //    Intent intent = new Intent(this.Context, typeof(NoteActivity));
            //    intent.PutExtra("noteHashCode", t.ItemHashCode);
            //    StartActivity(intent);


            //};
        }
        private List<DependantListItems> ConvertToDependantList(List<INote> notesList)
        {
            List<DependantListItems> dependantlist = new List<DependantListItems>();

            notesList.ForEach(item =>
            {
                dependantlist.Add(new DependantListItems
                {
                    Title = item.Title,
                    Description = item.ListText,
                    ItemHashCode = item.GetHashCode()
                });
            });

            return dependantlist;
        }

        public void OnDialogClose()
        {
            // ei ole päivittynyt
            var dependants = dataManager.GetDependantList().Items.Select(x => x.Name).ToList();
            spinner.Adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);

            var adapter = spinner.Adapter as SpinnerAdapter;
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);

            adapter.NotifyDataSetChanged();
            //this.View.RefreshDrawableState();
        }


        public class SpinnerAdapter : ArrayAdapter<string>
        {
            List<string> items;
            Activity context;
            public SpinnerAdapter(Activity context, int resource, List<string> items) : base(context, resource, items)
            {
                this.context = context;
                this.items = items;
            }
            public override View GetView(int position, View convertView, ViewGroup parent)
            {
                View view = convertView; // re-use an existing view, if one is available
                if (view == null) // otherwise create a new one
                    view = context.LayoutInflater.Inflate(Android.Resource.Layout.SimpleSpinnerItem, null);
                view.FindViewById<TextView>(Android.Resource.Id.Text1).Text = items[position];

                return view;
            }
        }
    }
}