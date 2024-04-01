using Android.Content;
using AndroidX.Activity.Result;
using AndroidX.Activity.Result.Contract;
using Google.Android.Material.Tabs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model.Note;
using AndroidX.AppCompat.App;

using Android.App;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;

using AndroidX.Fragment.App;
using AndroidX.Lifecycle;
using AndroidX.ViewPager2.Adapter;
using AndroidX.ViewPager2.Widget;
using Google.Android.Material.Tabs;

namespace Upkeep_Android
{
    public class ActivityBase : AppCompatActivity
    {
        private ActivityResultCallback _activityResultCallback;
        public ActivityResultLauncher _activityResultLauncher;
        public int _requestCode;
        public INote _note;
        //public void OnCreateActivity<T>(ref MyActivityResult<T> activity)
        protected override void OnCreate(Bundle savedInstanceState)
        {

            base.OnCreate(savedInstanceState);

            _activityResultCallback = new ActivityResultCallback();
            _activityResultCallback._activity = this;
            _activityResultLauncher = RegisterForActivityResult(new ActivityResultContracts.StartActivityForResult(), _activityResultCallback);

        }
        public virtual void ActivityResultReceived(int resultCode, Intent data)
        {
            if ((_note != null) || (resultCode == (int)Result.Ok))
            {
                //handle the result
            }
        }
        class ActivityResultCallback : Java.Lang.Object, IActivityResultCallback
        {
            public ActivityBase _activity;

            //public ActivityResultCallback(ref MyActivityResult<T> activity)
            //{
            //    _activity = activity; //initialise the parent activity/fragment here

            //}

            public void OnActivityResult(Java.Lang.Object? result)
            {
                var activityResult = result as ActivityResult;
                _activity?.ActivityResultReceived(activityResult.ResultCode, activityResult.Data); //pass the OnActivityResult data to parent class
            }
        }
    }
}
