using Android.App;
using Android.OS;
using Android.Runtime;
using Android.Widget;
using AndroidX.AppCompat.App;
using System.Collections.Generic;
using UpkeepBase.Data;
using UpkeepBase.Model;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme", MainLauncher = true)]
    public class MainActivity : AppCompatActivity
    {
        ListView mainList;
        private List<MainListItems> mlist;
        MainListAdapter adapter;

        DataManager dataManager;
        NotesList notesList;

        protected override void OnCreate(Bundle savedInstanceState)
        {
            dataManager = new DataManager();
            notesList = new NotesList();

            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.activity_main);

            mainList = (ListView)FindViewById<ListView>(Resource.Id.mainlistview);

//            List<MainListItems> objstud = ConvertToMainList(dataManager.GetDependantList());
            List<MainListItems> objstud = ConvertToMainList(notesList);

            mlist = new List<MainListItems>();
            mlist = objstud;
            adapter = new MainListAdapter(this, mlist);
            mainList.Adapter = adapter;
            mainList.ItemClick += (s, e) =>
            {
                var t = adapter[e.Position];
                Android.Widget.Toast.MakeText(this, t.Title, Android.Widget.ToastLength.Long).Show();
            };
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
                    Description = item.ListText
                });
            });

            return mainlist;
        }

        public override void OnRequestPermissionsResult(int requestCode, string[] permissions, [GeneratedEnum] Android.Content.PM.Permission[] grantResults)
        {
            Xamarin.Essentials.Platform.OnRequestPermissionsResult(requestCode, permissions, grantResults);

            base.OnRequestPermissionsResult(requestCode, permissions, grantResults);
        }


    }
}