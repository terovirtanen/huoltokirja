using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.RecyclerView.Widget;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UpkeepBase.Data;
using Fragment = AndroidX.Fragment.App.Fragment;

namespace Upkeep_Android
{
    public class ViewDependantScheduler : Fragment
    {

        public static ViewDependantScheduler NewInstance()
        {
            return new ViewDependantScheduler { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_scheduler, container, false);

            return view;
        }
    }
}