using Android.App;
using AndroidX.Fragment.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Fragment = AndroidX.Fragment.App.Fragment;
using UpkeepBase.Model;
using static Android.InputMethodServices.Keyboard;
using AndroidX.AppCompat.Widget;
using System.Runtime.InteropServices;

namespace Upkeep_Android
{
    public class ViewDependantBasic : Fragment
    {
        private static IDependant mDependant;

        public ViewDependantBasic() : base()
        {

        }
        public static ViewDependantBasic NewInstance(IDependant dependant)
        {
            mDependant = dependant;
            return new ViewDependantBasic { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_basic, container, false);

            if (mDependant != null)
            {
                var name = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantName);
                name.Text = mDependant.Name;
                var tag = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantTag);
                tag.Text = mDependant.TagsString;
            }

            return view;
        }
    }
}