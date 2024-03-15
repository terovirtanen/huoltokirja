using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.Activity.Result;
using AndroidX.Activity.Result.Contract;
using AndroidX.AppCompat.App;
using AndroidX.Fragment.App;
using AndroidX.Lifecycle;
using AndroidX.ViewPager2.Adapter;
using AndroidX.ViewPager2.Widget;
using Google.Android.Material.Tabs;
using System.Collections.Generic;
using System.Diagnostics;
using Upkeep_Android;
using UpkeepBase.Data;
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using static Android.Service.Voice.VoiceInteractionSession;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme", MainLauncher = true)]
    public class MainActivity : AppCompatActivity
    {
        ListView mainList;
        private List<MainListItems> mlist;
        //MainListAdapter mainlistadapter;


        ViewPager2 viewPager2;

        private ActivityResultCallback _activityResultCallback;
        public ActivityResultLauncher _activityResultLauncher;
        public static int _requestCode;
        public static INote _note;

        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);

            _activityResultCallback = new ActivityResultCallback(this);
            _activityResultLauncher = RegisterForActivityResult(new ActivityResultContracts.StartActivityForResult(), _activityResultCallback);

            Xamarin.Essentials.Platform.Init(this, savedInstanceState);

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.activity_main);

            viewPager2 = FindViewById<ViewPager2>(Resource.Id.mainViewPager);

            TabLayout tabLayout = FindViewById<TabLayout>(Resource.Id.mainTabLayout);

            var adapter = new MainActivityAdapter(this.SupportFragmentManager, this.Lifecycle, 2);

            viewPager2.Adapter = adapter;

            tabLayout.TabMode = TabLayout.ModeFixed;
            tabLayout.TabGravity = TabLayout.GravityCenter;
            TabLayoutMediator tabMediator = new TabLayoutMediator(tabLayout, viewPager2, new TabFullFilterConfigurationStrategy(this.BaseContext));
            tabMediator.Attach();


            var noteAddButton = FindViewById<Button>(Resource.Id.buttonAdd);

            noteAddButton.Click += (s, e) =>
            {
                var fm = SupportFragmentManager;
                var dialog = DialogNoteAddSelector.NewInstance(this);
                dialog.Show(fm, "dialog");
            };

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
        public void MyActivityResultReceived(int resultCode, Intent data)
        {
            if ((_note != null) || (resultCode == (int)Result.Ok))
            {
                foreach (var frag in this.SupportFragmentManager.Fragments)
                {
                    var viewRefresh = frag as IViewRefresh;
                    viewRefresh.RefreshData(_note);
                }
                //handle the result
            }
        }
        class ActivityResultCallback : Java.Lang.Object, IActivityResultCallback
        {
            MainActivity _mainActivity;
            public ActivityResultCallback(MainActivity mainActivity)
            {
                _mainActivity = mainActivity; //initialise the parent activity/fragment here
            }

            public void OnActivityResult(Java.Lang.Object result)
            {
                var activityResult = result as ActivityResult;
                _mainActivity.MyActivityResultReceived(activityResult.ResultCode, activityResult.Data); //pass the OnActivityResult data to parent class
            }
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
                    0 => "ViewList",
                    _ => "ViewDependantList"
                };

                tab.SetText(text);
            }
        }
        public class MainActivityAdapter : FragmentStateAdapter
        {
            private AndroidX.Fragment.App.FragmentManager _fragmentManager;
            public MainActivityAdapter(AndroidX.Fragment.App.FragmentManager fragmentManager, Lifecycle lifecylce, int itemCount) : base(fragmentManager, lifecylce)
            {
                this.itemCount = itemCount;
                this._fragmentManager = fragmentManager;
            }

            private readonly int itemCount;
            public override int ItemCount => itemCount;

            public FragmentActivity Fragment { get; }

            public override AndroidX.Fragment.App.Fragment CreateFragment(int position)
            {
                return position switch
                {
                    0 => ViewList.NewInstance(),
                    _ => ViewDependantList.NewInstance(_fragmentManager)

                };
            }

        }

    }
}