using Android.App;
using Android.OS;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using AndroidX.AppCompat.App;
using System;
using System.Collections.Generic;

namespace Upkeep_Android
{
    [Activity(Label = "@string/app_name", Theme = "@style/AppTheme", MainLauncher = true)]
    public class MainActivity : AppCompatActivity
    {
        string[] items;
        ListView mainList;
        private ListView studentlistView;
        private List<Students> mlist;
        StudentAdapter adapter;

        protected override void OnCreate(Bundle savedInstanceState)
        {
            base.OnCreate(savedInstanceState);
            Xamarin.Essentials.Platform.Init(this, savedInstanceState);

            items = new string[] {
                "Xamarin",
                "Android",
                "IOS",
                "Windows",
                "Xamarin-Native",
                "Xamarin-Forms"
            };

            // Set our view from the "main" layout resource
            SetContentView(Resource.Layout.activity_main);
            var data = new JavaList<IDictionary<string, object>>();
            data.Add(new JavaDictionary<string, object> {
              { "name", "Bruce Banner" },
              { "status", "Bruce Banner feels like SMASHING!" }
            });
            mainList = (ListView)FindViewById<ListView>(Resource.Id.mainlistview);
            //SimpleAdapter simpleadapter = new SimpleAdapter(this, getData(), Android.Resource.Layout.SimpleListItem2,
            //    new string[] { "textView1", "textView2" },
            //    new int[] { Resource.Id.textView1, Resource.Id.textView2 });

            //mainList.Adapter = simpleadapter;


            List<Students> objstud = new List<Students>();
            objstud.Add(new Students
            {
                Name = "Suresh",
                Age = 26
            });
            objstud.Add(new Students
            {
                Name = "C#Cornet",
                Age = 26
            });
            objstud.Add(new Students
            {
                Name = "JAva",
                Age = 28
            }); studentlistView = FindViewById<ListView>(Resource.Id.mainlistview);
            mlist = new List<Students>();
            mlist = objstud;
            adapter = new StudentAdapter(this, mlist);
            mainList.Adapter = adapter;
            //mainList.ItemClick += (s, e) => {
            //    var t = items[e.Position];
            //    Android.Widget.Toast.MakeText(this, t, Android.Widget.ToastLength.Long).Show();
            //};
        }
        public List<IDictionary<string, object>> getData()
        {

            List<IDictionary<string, object>> list = new List<IDictionary<string, object>>();
            for (int i = 0; i < 10; i++)
            {
                var item1 = new JavaDictionary<string, object>();
                item1.Add("textView1", "Title Mike Ma");
                item1.Add("textView2", "Body Mike Ma");
                list.Add(item1);
            }

            return list;
        }

        public override void OnRequestPermissionsResult(int requestCode, string[] permissions, [GeneratedEnum] Android.Content.PM.Permission[] grantResults)
        {
            Xamarin.Essentials.Platform.OnRequestPermissionsResult(requestCode, permissions, grantResults);

            base.OnRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }
    public class StudentAdapter : BaseAdapter<Students>
    {
        public List<Students> sList;
        private Activity sContext;
        public StudentAdapter(Activity context, List<Students> list)
        {
            sList = list;
            sContext = context;
        }
        public override Students this[int position]
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
    public class Students
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