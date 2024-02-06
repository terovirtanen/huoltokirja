
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
using UpkeepBase.Model;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme")]
    public class DependantActivity : AppCompatActivity
    {
        private Dependant mDependant;

        protected override void OnCreate(Bundle savedInstanceState)
        {

            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.activity_dependant);

            if (Intent.HasExtra("selectedDependantName"))
            {
                var selected = Intent.GetStringExtra("selectedDependantName");
                mDependant = (Application as UpKeepApplication).dataManager.GetDependantList().Items.Find(x => x.Name == selected) as Dependant;
            }

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