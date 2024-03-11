using Android.Content;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Upkeep_Android.Utils
{
    public class AlertHelper
    {
        static public Task<bool> AlertAsync(Context context, string title, string message, string positiveButton, string negativeButton = "")
        {
            var tcs = new TaskCompletionSource<bool>();

            using (var db = new AlertDialog.Builder(context))
            {
                db.SetTitle(title);
                db.SetMessage(message);
                db.SetPositiveButton(positiveButton, (sender, args) => { tcs.TrySetResult(true); });
                if (negativeButton != "")
                {
                    db.SetNegativeButton(negativeButton, (sender, args) => { tcs.TrySetResult(false); });
                }
                db.Show();
            }

            return tcs.Task;
        }
    }
}
