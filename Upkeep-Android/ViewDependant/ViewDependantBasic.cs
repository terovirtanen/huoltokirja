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

    public class ViewDependantBasic : Fragment, IOnDialogCloseListener
    {
        private static Dependant mDependant;

        public ViewDependantBasic() : base()
        {

        }
        public static ViewDependantBasic NewInstance(IDependant dependant)
        {
            mDependant = dependant as Dependant;
            return new ViewDependantBasic { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_dependant_basic, container, false);

            ElementSet(view);

            return view;
        }


        public override void OnDestroyView()
        {
            ElementSave(View);

            base.OnDestroyView();
        }

        private void ElementSet(View view)
        {
            var elementName = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantName);
            var elementTag = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantTag);
            var elementUnit = view.FindViewById<Spinner>(Resource.Id.editDependantUnit);

            var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, Constansts.CounterUnits);
            adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            elementUnit.Adapter = adapter;

            if (mDependant != null)
            {
                elementName.Text = mDependant.Name;
                elementTag.Text = mDependant.TagsString;

                var index = Array.FindIndex(Constansts.CounterUnits, r => r == mDependant.CounterUnit);

                elementUnit.SetSelection(index);
            }
        }

        //spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
        //    spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
        //    //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //    var adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
        //    spinner.Adapter = adapter;
        private void ElementSave(View view)
        {
            var elementName = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantName);
            var elementTag = view.FindViewById<AppCompatEditText>(Resource.Id.editDependantTag);
            var elementUnit = view.FindViewById<Spinner>(Resource.Id.editDependantUnit);

            if (mDependant != null)
            {
                mDependant.Name = elementName.Text;
                mDependant.TagsString = elementTag.Text;
                mDependant.CounterUnit = elementUnit.SelectedItem.ToString();
            }
        }

        public void OnDialogClose()
        {
            ElementSave(View);
        }
    }
}