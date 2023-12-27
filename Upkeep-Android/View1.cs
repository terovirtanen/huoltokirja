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
    public class View1 : Fragment
    {
        public static View1 NewInstance()
        {
            return new View1 { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view1, container, false);

            return view;
        }
    }
}