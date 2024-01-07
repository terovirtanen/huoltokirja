using Android.App;
using Android.Content;
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
using Fragment = AndroidX.Fragment.App.Fragment;

namespace Upkeep_Android
{
    public class ViewDependantList : Fragment
    {
        private DataManager dataManager;
        public static ViewDependantList NewInstance()
        {
            return new ViewDependantList { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_list, container, false);

            dataManager = new DataManager();

            var dependants = dataManager.GetDependantList().Items.Select(x => x.Name).ToList();

            Spinner spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
            spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
            var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            spinner.Adapter = adapter;


            TextView textfield = view.FindViewById<TextView>(Resource.Id.dependantText);
            textfield.Text = dependants.FirstOrDefault();

            var dependantList = (ListView)view.FindViewById<ListView>(Resource.Id.dependantlistview);

            var notesList = dataManager.GetDependantList().Items.Where(x => x.Name == textfield.Text).First().NItemsOrderByDescendingByEventTime;
            List<DependantListItems> objstud = ConvertToDependantList(notesList);

            var mlist = new List<DependantListItems>();
            mlist = objstud;
            var mainlistadapter = new DependantListAdapter(this.Context as Activity, mlist);
            dependantList.Adapter = mainlistadapter;



            return view;
        }
        private List<DependantListItems> ConvertToDependantList(List<INote> notesList)
        {
            List<DependantListItems> dependantlist = new List<DependantListItems>();

            notesList.ForEach(item =>
            {
                dependantlist.Add(new DependantListItems
                {
                    Title = item.Title,
                    Description = item.ListText
                });
            });

            return dependantlist;
        }

        private void spinner_ItemSelected(object sender, AdapterView.ItemSelectedEventArgs e)
        {
            Spinner spinner = (Spinner)sender;
            var selected = spinner.GetItemAtPosition(e.Position);
            string toast = string.Format("The dependant is {0}", selected);
            
            TextView textfield = this.View.FindViewById<TextView>(Resource.Id.dependantText);
            textfield.Text = selected.ToString();


            var dependantList = (ListView)this.View.FindViewById<ListView>(Resource.Id.dependantlistview);

            var notesList = dataManager.GetDependantList().Items.Where(x => x.Name == textfield.Text).First().NItemsOrderByDescendingByEventTime;
            List<DependantListItems> objstud = ConvertToDependantList(notesList);

            var mlist = new List<DependantListItems>();
            mlist = objstud;
            var mainlistadapter = new DependantListAdapter(this.Context as Activity, mlist);
            dependantList.Adapter = mainlistadapter;


            Toast.MakeText(this.Context as Activity, toast, ToastLength.Long).Show();
        }
    }
}