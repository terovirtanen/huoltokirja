﻿using Android.App;
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
using static Java.IO.ObjectInputStream;
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

            RefresfListViewData(view, dependants.FirstOrDefault());

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
            var dependantItem = dataManager.GetDependantList().Items.Where(x => x.Name == dependantName).First();

            TextView textfield = _view.FindViewById<TextView>(Resource.Id.dependantText);

            // show text field only if something to present
            dependantItem.CalculateCounterEstimate();
            textfield.Text = dependantItem.CounterEstimate;
            //textfield.Visibility = (textfield.Text == "") ? ViewStates.Gone : ViewStates.Visible;

            var notesList = dependantItem.NItemsOrderByDescendingByEventTime;
            List<DependantListItems> objstud = ConvertToDependantList(notesList);

            var mlist = new List<DependantListItems>();
            mlist = objstud;
            var mainlistadapter = new DependantListAdapter(this.Context as Activity, mlist);

            var dependantList = (ListView)_view.FindViewById<ListView>(Resource.Id.dependantlistview);
            dependantList.Adapter = mainlistadapter;
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

    }
}