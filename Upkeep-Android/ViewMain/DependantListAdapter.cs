using Android.App;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;

namespace Upkeep_Android
{

    public class DependantListAdapter : BaseAdapter<DependantListItems>
    {
        public List<DependantListItems> sList;
        private Activity sContext;

        public DependantListAdapter(Activity context, List<DependantListItems> list)
        {
            sList = list;
            sContext = context;
        }

        public override DependantListItems this[int position]
        {
            get
            {
                return sList[position];
            }
        }
        public override int Count
        {
            get
            {
                return sList.Count;
            }
        }
        public override long GetItemId(int position)
        {
            return position;
        }
        public override View GetView(int position, View convertView, ViewGroup parent)
        {
            View row = convertView;
            try
            {
                if (row == null)
                {
                     row = sContext.LayoutInflater.Inflate(Resource.Layout.activity_row_main, null, false);
                }
                TextView txtName = row.FindViewById<TextView>(Resource.Id.textView1);
                TextView txtName2 = row.FindViewById<TextView>(Resource.Id.textView2);

                txtName.Text = sList[position].Title;
                txtName2.Text = sList[position].Description;
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally { }
            return row;
        }
    }
    public class DependantListItems
    {
        public string Title
        {
            get;
            set;
        }
        public string Description
        {
            get;
            set;
        }
        public int ItemHashCode
        {
            get;
            set;
        }
    }
}