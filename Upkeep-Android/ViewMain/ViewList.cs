using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.Activity.Result;
using AndroidX.Fragment.App;
using AndroidX.ViewPager2.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using static Android.Icu.Text.Transliterator;
using Fragment = AndroidX.Fragment.App.Fragment;

namespace Upkeep_Android
{
    public class ViewList : Fragment, IViewRefresh
    {
        ListView mainList;
        private List<MainListItems> mlist;

        private MainListAdapter mainListAdapter;
        private NotesList notesList;
        public static ViewList NewInstance()
        {
            return new ViewList { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_list, container, false);

            mainList = view.FindViewById<ListView>(Resource.Id.mainlistview);

            RefreshListViewData(mainList);
            //var notesList = new NotesList();
            //List<MainListItems> objstud = ConvertToMainList(notesList);

            //mlist = new List<MainListItems>();
            //mlist = objstud;
            //mainListAdapter = new MainListAdapter(Context as Activity, mlist);
            //mainList.Adapter = mainListAdapter;

            mainList.ItemClick += (s, e) =>
            {
                var t = mainListAdapter[e.Position];
                //Toast.MakeText(this.Context, t.Title, ToastLength.Long).Show();

                //Intent intent = new Intent(this.Context, typeof(DependantActivity));
                //StartActivity(intent);
                var note = notesList.GetByHashCode(t.ItemHashCode);

                NoteActivity.mNote = note;

                Intent intent = new Intent(this.Context, typeof(NoteActivity));
                intent.PutExtra("noteHashCode", t.ItemHashCode);
                //StartActivity(intent);

                MainActivity._requestCode = 1001;  //flag to handle the multiple intent request 
                MainActivity._note = note;
                (this.Context as MainActivity)._activityResultLauncher.Launch(intent);
            };

            return view;
        }
        public override void OnResume()
        {
            base.OnResume();

            RefreshListViewData(mainList);

        }
        private void RefreshListViewData(ListView _mainList)
        {
            notesList = new NotesList();
            List<MainListItems> objstud = ConvertToMainList(notesList);

            mlist = new List<MainListItems>();
            mlist = objstud;

            if (_mainList.Adapter != null) { 
                (_mainList.Adapter as MainListAdapter).UpdateItems(mlist);
            } else
            {
                mainListAdapter = new MainListAdapter(this.Context as Activity, mlist);
                _mainList.Adapter = mainListAdapter;
            }
        }

        private List<MainListItems> ConvertToMainList(NotesList _notesList)
        {
            List<MainListItems> mainlist = new List<MainListItems>();

            var items = _notesList.Items;

            items.ForEach(item =>
            {
                mainlist.Add(new MainListItems
                {
                    Title = item.Title,
                    Description = item.ListText,
                    ItemHashCode = item.GetHashCode()
                });
            });

            return mainlist;
        }

        public void RefreshData(INote note)
        {
            RefreshListViewData(mainList);
        }
    }
}