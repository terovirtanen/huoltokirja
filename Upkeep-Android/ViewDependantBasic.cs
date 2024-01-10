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

namespace Upkeep_Android
{
    public class ViewDependantBasic : Fragment
    {
        public static ViewDependantBasic NewInstance()
        {
            return new ViewDependantBasic { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_basic, container, false);

            return view;
        }
    }
}