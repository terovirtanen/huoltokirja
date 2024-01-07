using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.AppCompat.App;
using AndroidX.Fragment.App;
using AndroidX.Lifecycle;
using AndroidX.ViewPager2.Adapter;
using AndroidX.ViewPager2.Widget;
using Google.Android.Material.Tabs;
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
        //MainListAdapter mainlistadapter;

        DataManager dataManager;
        NotesList notesList;

        ViewPager2 viewPager2;

        protected override void OnCreate(Bundle savedInstanceState)
        {
            dataManager = new DataManager();
            notesList = new NotesList();

            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.activity_main);

            viewPager2 = FindViewById<ViewPager2>(Resource.Id.mainViewPager);

            TabLayout tabLayout = FindViewById<TabLayout>(Resource.Id.mainTabLayout);

            var adapter = new MainMMMAdapter(this.SupportFragmentManager, this.Lifecycle, 3);

            viewPager2.Adapter = adapter;

            tabLayout.TabMode = TabLayout.ModeFixed;
            tabLayout.TabGravity = TabLayout.GravityCenter;
            TabLayoutMediator tabMediator = new TabLayoutMediator(tabLayout, viewPager2, new TabFullFilterConfigurationStrategy(this.BaseContext));
            tabMediator.Attach();


            //// mainlist view stuff
            //mainList = (ListView)FindViewById<ListView>(Resource.Id.mainlistview);

            ////            List<MainListItems> objstud = ConvertToMainList(dataManager.GetDependantList());
            //List<MainListItems> objstud = ConvertToMainList(notesList);

            //mlist = new List<MainListItems>();
            //mlist = objstud;
            //var mainlistadapter = new MainListAdapter(this, mlist);
            //mainList.Adapter = new MainListAdapter(this, mlist);
         //   mainList.Adapter = mainlistadapter;
            //mainList.ItemClick += (s, e) =>
            //{
            //    //var t = adapter[e.Position];
            //    //Android.Widget.Toast.MakeText(this, t.Title, Android.Widget.ToastLength.Long).Show();

            //    var fm = SupportFragmentManager;
            //    var dialog = MainDialogFragment.NewInstance(this);
            //    dialog.Show(fm, "dialog");
            //};
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

        //In this class, in the method OnConfigureTab, you change the Tab Titles based on its location
        public class TabFullFilterConfigurationStrategy : Java.Lang.Object, TabLayoutMediator.ITabConfigurationStrategy
        {
            private readonly Context context;

            public TabFullFilterConfigurationStrategy(Context context)
            {
                this.context = context;
            }

            public void OnConfigureTab(TabLayout.Tab tab, int position)
            {
                string text = position switch
                {
                    0 => "View 1",
                    1 => "View 2",
                    _ => "ViewList"
                };

                tab.SetText(text);
            }
        }
        public class MainMMMAdapter : FragmentStateAdapter
        {
            public MainMMMAdapter(AndroidX.Fragment.App.FragmentManager fragmentManager, Lifecycle lifecylce, int itemCount) : base(fragmentManager, lifecylce)
            {
                this.itemCount = itemCount;
            }

            private readonly int itemCount;
            public override int ItemCount => itemCount;

            public FragmentActivity Fragment { get; }

            public override AndroidX.Fragment.App.Fragment CreateFragment(int position)
            {
                return position switch
                {
                    0 => View1.NewInstance(),
                    1 => View2.NewInstance(),
                    _ => ViewList.NewInstance()

                };
            }

        }

    }
}