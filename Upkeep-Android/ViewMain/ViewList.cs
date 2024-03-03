using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.Fragment.App;
using AndroidX.ViewPager2.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using UpkeepBase.Model;
using static Android.Icu.Text.Transliterator;
using Fragment = AndroidX.Fragment.App.Fragment;

namespace Upkeep_Android.ViewMain
{
    public class ViewList : Fragment
    {
        ListView mainList;
        private List<MainListItems> mlist;
        public static ViewList NewInstance()
        {
            return new ViewList { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_list, container, false);

            mainList = view.FindViewById<ListView>(Resource.Id.mainlistview);

            var notesList = new NotesList();
            List<MainListItems> objstud = ConvertToMainList(notesList);

            mlist = new List<MainListItems>();
            mlist = objstud;
            var mainlistadapter = new MainListAdapter(Context as Activity, mlist);
            mainList.Adapter = mainlistadapter;

            mainList.ItemClick += (s, e) =>
            {
                var t = mainlistadapter[e.Position];
                //Toast.MakeText(this.Context, t.Title, ToastLength.Long).Show();

                //Intent intent = new Intent(this.Context, typeof(DependantActivity));
                //StartActivity(intent);
                var note = notesList.GetByHashCode(t.ItemHashCode);

                NoteActivity.mNote = note;

                Intent intent = new Intent(this.Context, typeof(NoteActivity));
                intent.PutExtra("noteHashCode", t.ItemHashCode);
                StartActivity(intent);
            };

            return view;
        }
        private List<MainListItems> ConvertToMainList(NotesList notesList)
        {
            List<MainListItems> mainlist = new List<MainListItems>();

            var items = notesList.Items;

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
    }
}