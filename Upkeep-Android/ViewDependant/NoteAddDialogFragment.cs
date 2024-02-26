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

    public partial class NoteAddDialogFragment : DialogFragment
    {
        static Context mContext;
        private IDependant mSelectedDependant;
        private IOnDialogCloseListener mListener;

        private NoteAddDialogFragment(IDependant dependant, IOnDialogCloseListener listener) : base()
        {
            mSelectedDependant = dependant;
            mListener = listener;
        }
        public static NoteAddDialogFragment NewInstance(Context context)
        {
            mContext = context;
            return new NoteAddDialogFragment(null, null);
        }
        public static NoteAddDialogFragment NewInstance(Context context, IDependant dependant, IOnDialogCloseListener listener)
        {
            mContext = context;

            return new NoteAddDialogFragment(dependant, listener);
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            var view = inflater.Inflate(Resource.Layout.view_note_add, container, false);


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

            if (mListener != null)
            {
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

            //ViewPager2 viewPager2 = view.FindViewById<ViewPager2>(Resource.Id.dependantViewPager);

        }
    }

}