using Android.App;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.AppCompat.App;
using System;
using System.Collections.Generic;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme", MainLauncher = true)]
    public class MainActivity : AppCompatActivity
    {
        ListView mainList;
        private ListView mainlistView;
        private List<MainListItems> mlist;
        MainListAdapter adapter;

        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.activity_main);

            mainList = (ListView)FindViewById<ListView>(Resource.Id.mainlistview);

            List<MainListItems> objstud = new List<MainListItems>();
            objstud.Add(new MainListItems
            {
                Name = "Suresh",
                Age = 26
            });
            objstud.Add(new MainListItems
            {
                Name = "C#Cornet",
                Age = 26
            });
            objstud.Add(new MainListItems
            {
                Name = "JAva",
                Age = 28
            }); 
            mainlistView = FindViewById<ListView>(Resource.Id.mainlistview);
            mlist = new List<MainListItems>();
            mlist = objstud;
            adapter = new MainListAdapter(this, mlist);
            mainList.Adapter = adapter;
            //mainList.ItemClick += (s, e) => {
            //    var t = items[e.Position];
            //    Android.Widget.Toast.MakeText(this, t, Android.Widget.ToastLength.Long).Show();
            //};
        }


        public override void OnRequestPermissionsResult(int requestCode, string[] permissions, [GeneratedEnum] Android.Content.PM.Permission[] grantResults)
        {
            Xamarin.Essentials.Platform.OnRequestPermissionsResult(requestCode, permissions, grantResults);

            base.OnRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
}