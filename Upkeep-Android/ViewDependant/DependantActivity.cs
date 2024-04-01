
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
using UpkeepBase.Model;
using UpkeepBase.Model.Note;
using static Android.App.Instrumentation;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme")]
    public class DependantActivity : ActivityBase
    {
        private Dependant mDependant;

        protected override void OnCreate(Bundle savedInstanceState)
        {

            base.OnCreate(savedInstanceState);

            //_activityResultCallback = new ActivityResultCallback(this);
            //_activityResultLauncher = RegisterForActivityResult(new ActivityResultContracts.StartActivityForResult(), _activityResultCallback);

            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.activity_dependant);

            if (Intent.HasExtra("selectedDependantName"))
            {
                var selected = Intent.GetStringExtra("selectedDependantName");
                mDependant = (Application as UpKeepApplication).dataManager.GetDependantList().Items.Find(x => x.Name == selected) as Dependant;
            }
            
            var addNoteButton = FindViewById<Button>(Resource.Id.buttonAddNote);
            addNoteButton.Click += (s, e) =>
            {
                var fm = SupportFragmentManager;
                var dialog = DialogNoteAddSelector.NewInstance(this);
                dialog.Show(fm, "dialog");
            };

            var dependantButton = FindViewById<Button>(Resource.Id.buttonDependantFinish);
            dependantButton.Click += (s, e) =>
            {
                Finish();
            };


            ViewPager2 viewPager2 = FindViewById<ViewPager2>(Resource.Id.dependantViewPager);

            TabLayout tabLayout = FindViewById<TabLayout>(Resource.Id.dependantTabLayout);

            var adapter = new DependantActivityAdapter(this.SupportFragmentManager, this.Lifecycle, 3);
            adapter.mSelectedDependant = mDependant;

            viewPager2.Adapter = adapter;

            tabLayout.TabMode = TabLayout.ModeFixed;
            tabLayout.TabGravity = TabLayout.GravityCenter;

            TabLayoutMediator tabMediator = new TabLayoutMediator(tabLayout, viewPager2, new TabFullFilterConfigurationStrategy(this.BaseContext));
            tabMediator.Attach();
            //var textDependantActivity = FindViewById<TextView>(Resource.Id.textDependantActivity);
            //textDependantActivity.Text = "Set in here";
        }
        public override void OnRequestPermissionsResult(int requestCode, string[] permissions, [GeneratedEnum] Android.Content.PM.Permission[] grantResults)
        {
            Xamarin.Essentials.Platform.OnRequestPermissionsResult(requestCode, permissions, grantResults);

            base.OnRequestPermissionsResult(requestCode, permissions, grantResults);
        }

        //private ActivityResultCallback _activityResultCallback;
        //public ActivityResultLauncher _activityResultLauncher;
        //public static int _requestCode;
        //public static INote _note;

        public override void ActivityResultReceived(int resultCode, Intent data)
        {
            if ((_note != null) || (resultCode == (int)Result.Ok))
            {
                foreach (var frag in this.SupportFragmentManager.Fragments)
                {
                    //if (frag is IViewRefresh) { 
                    //    var viewRefresh = frag as IViewRefresh;
                    //    viewRefresh.RefreshData(_note);

                    //    TabLayout tabLayout = FindViewById<TabLayout>(Resource.Id.dependantTabLayout);
                    //    tabLayout.GetTabAt(1).Select();
                    //}
                }
                //handle the result
            }
        }
        //class ActivityResultCallback : Java.Lang.Object, IActivityResultCallback
        //{
        //    DependantActivity _activity;
        //    public ActivityResultCallback(DependantActivity activity)
        //    {
        //        _activity = activity; //initialise the parent activity/fragment here
        //    }

        //    public void OnActivityResult(Java.Lang.Object result)
        //    {
        //        var activityResult = result as ActivityResult;
        //        _activity.MyActivityResultReceived(activityResult.ResultCode, activityResult.Data); //pass the OnActivityResult data to parent class
        //    }
        //}


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
                    0 => "Basic",
                    1 => "Notes",
                    _ => "Schedules"
                };


                tab.SetText(text);
            }
        }
        public class DependantActivityAdapter : FragmentStateAdapter
        {
            private AndroidX.Fragment.App.FragmentManager _fragmentManager;
            public IDependant mSelectedDependant;
            public DependantActivityAdapter(AndroidX.Fragment.App.FragmentManager fragmentManager, Lifecycle lifecylce, int itemCount) : base(fragmentManager, lifecylce)
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
                    0 => ViewDependantBasic.NewInstance(mSelectedDependant),
                    1 => ViewDependantNote.NewInstance(mSelectedDependant),
                    _ => ViewDependantScheduler.NewInstance()
                };
            }

        }
    }
}