using Android.App;
using Android.Views;
using Android.Widget;
using System;
using System.Collections.Generic;

namespace Upkeep_Android
{

    public class MainListAdapter : BaseAdapter<MainListItems>
    {
        public List<MainListItems> sList;
        private Activity sContext;
        public MainListAdapter(Activity context, List<MainListItems> list)
        {
            sList = list;
            sContext = context;
        }
        public override MainListItems this[int position]
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
                    row = sContext.LayoutInflater.Inflate(Resource.Layout.activity_main, null, false);
                }
                TextView txtName = row.FindViewById<TextView>(Resource.Id.textView1);
                TextView txtName2 = row.FindViewById<TextView>(Resource.Id.textView2);

                txtName.Text = sList[position].Name;
                txtName2.Text = sList[position].Age.ToString();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
            finally { }
            return row;
        }
    }
    public class MainListItems
    {
        public string Name
        {
            get;
            set;
        }
        public int Age
        {
            get;
            set;
        }
    }
}