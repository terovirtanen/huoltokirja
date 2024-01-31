using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.Fragment.App;
using AndroidX.Lifecycle;
using AndroidX.ViewPager.Widget;
using AndroidX.ViewPager2.Adapter;
using AndroidX.ViewPager2.Widget;
using Google.Android.Material.Tabs;
using Java.Lang;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UpkeepBase.Model;
using DialogFragment = AndroidX.Fragment.App.DialogFragment;
using Fragment = AndroidX.Fragment.App.Fragment;
using FragmentManager = AndroidX.Fragment.App.FragmentManager;

namespace Upkeep_Android
{

    public partial class MainDialogFragment : DialogFragment
    {
        static Context mContext;
        private IDependant mSelectedDependant;
        private IOnDialogCloseListener mListener;

        private MainDialogFragment(IDependant dependant, IOnDialogCloseListener listener) : base()
        {
            mSelectedDependant = dependant;
            mListener = listener;
        }
        public static MainDialogFragment NewInstance(Context context)
        {
            mContext = context;
            return new MainDialogFragment(null, null);
        }
        public static MainDialogFragment NewInstance(Context context, IDependant dependant, IOnDialogCloseListener listener)
        {
            mContext = context;

            return new MainDialogFragment(dependant, listener);
        }
        
        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            var view = inflater.Inflate(Resource.Layout.main_tabbed_dialog, container, false);


            var btnOK = view.FindViewById<Button>(Resource.Id.buttonDependantOK);

            btnOK.Click += BtnOK_Click;

            return view;
        }
        public override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);
            SetStyle(DialogFragment.StyleNoTitle, Resource.Style.DialogStyle);

        }
        public override void Dismiss()
        {
            base.Dismiss();

            if (mListener != null) {
                //ViewPager2 viewPager2 = View.FindViewById<ViewPager2>(Resource.Id.dependantViewPager);
                //var basic = viewPager2.Adapter.GetItemId(0);
                var t = this.ChildFragmentManager;

                ChildFragmentManager.Fragments.ToList().ForEach(frag =>
                {
                    (frag as IOnDialogCloseListener).OnDialogClose();
                });

                mListener.OnDialogClose();
            }
        }
        private void BtnOK_Click(object sender, EventArgs e)
        {
            Dismiss();
        }

        public override void OnViewCreated(View view, Bundle savedInstanceState)
        {
            base.OnViewCreated(view, savedInstanceState);

            ViewPager2 viewPager2 = view.FindViewById<ViewPager2>(Resource.Id.dependantViewPager);

            TabLayout tabLayout = view.FindViewById<TabLayout>(Resource.Id.tabLayout);

            var adapter = new MainDialogAdapter(ChildFragmentManager, ViewLifecycleOwner.Lifecycle, 3);
            adapter.mSelectedDependant = mSelectedDependant;

            viewPager2.Adapter = adapter;

            tabLayout.TabMode = TabLayout.ModeFixed;
            tabLayout.TabGravity = TabLayout.GravityCenter;

            TabLayoutMediator tabMediator = new TabLayoutMediator(tabLayout, viewPager2, new TabFullFilterConfigurationStrategy(Activity));
            tabMediator.Attach();
        }
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
                0 => "Basic",
                1 => "Notes",
                _ => "Schedules"
            };

            tab.SetText(text);
        }
    }

    public class MainDialogAdapter : FragmentStateAdapter
    {
        public IDependant mSelectedDependant;

        public MainDialogAdapter(FragmentManager fragmentManager, Lifecycle lifecylce, int itemCount) : base(fragmentManager, lifecylce)
        {
            this.itemCount = itemCount;
        }

        private readonly int itemCount;
        public override int ItemCount => itemCount;

        public FragmentActivity Fragment { get; }

        public override Fragment CreateFragment(int position)
        {
            return position switch
            {
                0 => ViewDependantBasic.NewInstance(mSelectedDependant),
                1 => ViewDependantNote.NewInstance(),
                _ => ViewDependantScheduler.NewInstance()
            };
        }
    }
}