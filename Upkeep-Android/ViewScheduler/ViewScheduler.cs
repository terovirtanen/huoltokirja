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
using Java.Lang.Annotation;
using UpkeepBase.Forms.Model.Scheduler;

namespace Upkeep_Android
{

    public class ViewScheduler : Fragment, IOnDialogCloseListener
    {
        private static IScheduler mScheduler;

        TextView _dateDisplay;

        public ViewScheduler() : base()
        {

        }
        public static ViewScheduler NewInstance(IScheduler scheduler)
        {
            mScheduler = scheduler as IScheduler;
            return new ViewScheduler { Arguments = new Bundle() };
        }

        public override View OnCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState)
        {
            base.OnCreateView(inflater, container, savedInstanceState);

            var view = inflater.Inflate(Resource.Layout.view_scheduler, container, false);

            LinearLayout parentLayout = view.FindViewById<LinearLayout>(Resource.Id.schedulerParentLinearLayout);

            var _view = inflater.Inflate(Resource.Layout.view_scheduler_timing, null);
            parentLayout.AddView(_view);


            ElementSet(view);

            //var elementDate = view.FindViewById<TextView>(Resource.Id.schedulerDate);
            var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerDate);
            elementDate.Text = mScheduler.StartTime.ToShortDateString();

            elementDate.Click += (s, e) =>
            {
                var elementDate = view.FindViewById<TextView>(Resource.Id.schedulerDate);
                DatePickerFragment frag = DatePickerFragment.NewInstance(delegate (DateTime time)
                {
                    elementDate.Text = time.ToShortDateString();
                });
                frag.Show(this.ChildFragmentManager, DatePickerFragment.TAG);
            };

            return view;
        }

        public override void OnPause()
        {
            ElementSave(View);
            base.OnPause();
        }
        
        private void ElementSet(View view)
        {
            var elementTitle = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerTitle);
            var elementDescription = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerDescription);
            //var elementType = view.FindViewById<Spinner>(Resource.Id.schedulerTypeSpinner);

            //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, Constansts.schedulerTypes);
            //adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
            //elementType.Adapter = adapter;

            if (mScheduler != null)
            {
                elementTitle.Text = mScheduler.Title;
                elementDescription.Text = mScheduler.Description;

                //var index = 2;
                //if (mScheduler.GetType().Name == "Service") { index = 1; }
                //if (mScheduler.GetType().Name == "Inspection") { index = 0; }

                //elementType.SetSelection(index);
            }

            ElementSetTiming(view);
        }
        private void ElementSetTiming(View view)
        {
            var elementAnnual = view.FindViewById<CheckBox>(Resource.Id.schedulerCheckboxAnnually);
            var elementBiannual = view.FindViewById<CheckBox>(Resource.Id.schedulerCheckboxBiannually);
            var elementQuaterly = view.FindViewById<CheckBox>(Resource.Id.schedulerCheckboxQuaterly);

            var elementCustomPeriodMonths = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerMonthPeriod);
            var elementCounterValue = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerCounterValue);
            var elementStartCounterValue = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerStartCounterValue);

            if (mScheduler != null)
            {
                elementAnnual.Checked = mScheduler.Annual;
                elementBiannual.Checked = mScheduler.Biannual;
                elementQuaterly.Checked = mScheduler.Quaterly;

                elementCustomPeriodMonths.Text = mScheduler.CustomPeriodMonths.ToString();
                elementCounterValue.Text = mScheduler.CounterValue.ToString();
                elementStartCounterValue.Text = mScheduler.StartCounterValue.ToString();
            }
        }

        void DateSelect_OnClick(object sender, EventArgs eventArgs)
        {
            DatePickerFragment frag = DatePickerFragment.NewInstance(delegate (DateTime time)
            {
                _dateDisplay.Text = time.ToLongDateString();
            });
            frag.Show(FragmentManager, DatePickerFragment.TAG);
        }
        //spinner = view.FindViewById<Spinner>(Resource.Id.dependantSpinner);
        //    spinner.ItemSelected += new EventHandler<AdapterView.ItemSelectedEventArgs>(spinner_ItemSelected);
        //    //var adapter = new ArrayAdapter<String>(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //    var adapter = new SpinnerAdapter(this.Context as Activity, Android.Resource.Layout.SimpleSpinnerItem, dependants);
        //adapter.SetDropDownViewResource(Android.Resource.Layout.SimpleSpinnerDropDownItem);
        //    spinner.Adapter = adapter;
        private void ElementSave(View view)
        {
            var elementTitle = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerTitle);
            var elementDescription = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerDescription);
            var elementDate = view.FindViewById<AppCompatEditText>(Resource.Id.schedulerDate);


            if (mScheduler != null)
            {
                mScheduler.Title = elementTitle.Text;
                mScheduler.Description = elementDescription.Text;
                mScheduler.StartTime = DateTime.Parse(elementDate.Text);


                mScheduler.Annual =  view.FindViewById<AppCompatCheckBox>(Resource.Id.schedulerCheckboxAnnually).Checked;
                mScheduler.Biannual =  view.FindViewById<AppCompatCheckBox>(Resource.Id.schedulerCheckboxBiannually).Checked;
                mScheduler.Quaterly =  view.FindViewById<AppCompatCheckBox>(Resource.Id.schedulerCheckboxQuaterly).Checked;

                mScheduler.CustomPeriodMonths = Convert.ToInt32(view.FindViewById<AppCompatEditText>(Resource.Id.schedulerMonthPeriod).Text);
                mScheduler.CounterValue = Convert.ToInt32(view.FindViewById<AppCompatEditText>(Resource.Id.schedulerCounterValue).Text);
                mScheduler.StartCounterValue = Convert.ToInt32(view.FindViewById<AppCompatEditText>(Resource.Id.schedulerStartCounterValue).Text);
            }
        }

        public void OnDialogClose()
        {
            ElementSave(View);
        }
    }
}