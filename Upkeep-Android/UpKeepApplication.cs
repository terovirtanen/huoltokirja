using Android.App;
using Android.Runtime;
using UpkeepBase.Data;

[Application]
public class UpKeepApplication : Application
{
    public DataManager dataManager;
    protected UpKeepApplication(System.IntPtr javaReference, JniHandleOwnership transfer) : base(javaReference, transfer)
    {
    }
    public override void OnCreate()
    {
        base.OnCreate();

        dataManager = DataManager.GetInstance();
    }
}