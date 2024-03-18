
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
using UpkeepBase.Model.Note;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme")]
    public class NoteActivity : AppCompatActivity
    {
        public static INote mNote;

        protected override void OnCreate(Bundle savedInstanceState)
        {

            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);
            SetContentView(Resource.Layout.activity_note);

            //if (Intent.HasExtra("noteHashCode"))
            //{
            //    var selectedHashCode = Intent.GetStringExtra("noteHashCode");
            //    mNote = (Application as UpKeepApplication).dataManager.GetDependantList().Items.Find(x => x.Name == selected) as Dependant;
            //}

            var noteFinishButton = FindViewById<Button>(Resource.Id.buttonNoteFinish);

            noteFinishButton.Click += (s, e) =>
            {
                Finish();
            };


            ViewPager2 viewPager2 = FindViewById<ViewPager2>(Resource.Id.noteViewPager);

            TabLayout tabLayout = FindViewById<TabLayout>(Resource.Id.noteTabLayout);

            var adapter = new NoteActivityAdapter(this.SupportFragmentManager, this.Lifecycle, 1);
            adapter.mSelectedNote = mNote;

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
                    //0 => "Basic",
                    //1 => "Service",
                    //_ => "Inspection"
                    _ => "Basic"
                };


                tab.SetText(text);
            }
        }
        public class NoteActivityAdapter : FragmentStateAdapter
        {
            private AndroidX.Fragment.App.FragmentManager _fragmentManager;
            public INote mSelectedNote;
            public NoteActivityAdapter(AndroidX.Fragment.App.FragmentManager fragmentManager, Lifecycle lifecylce, int itemCount) : base(fragmentManager, lifecylce)
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
                    //0 => ViewNoteBasic.NewInstance(mSelectedNote),
                    //1 => ViewNoteBasic.NewInstance(mSelectedNote),
                    _ => ViewNoteBasic.NewInstance(mSelectedNote)
                };
            }

        }
    }
}