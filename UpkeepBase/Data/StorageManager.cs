using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UpkeepBase.Model;
using Newtonsoft.Json;
using System.IO;

namespace UpkeepBase.Data
{
    internal class StorageManager
    {
        private String fileName = "storage.json";
        public void WriteToJson(DependantList depandantList)
        {

            string jsonString = GetJsonString(depandantList);
            File.WriteAllText(fileName, jsonString, Encoding.UTF8);
        }
        public DependantList ReadFromJson()
        {
            var settings = new JsonSerializerSettings { 
                TypeNameHandling = TypeNameHandling.Auto,
                NullValueHandling = NullValueHandling.Ignore
            };

            var content = File.ReadAllText(fileName);
            var deplist = JsonConvert.DeserializeObject<DependantList>(content, settings);
            return deplist;
        }
        private string GetJsonString(DependantList depandantList)
        {
            var settings = new JsonSerializerSettings { 
                TypeNameHandling = TypeNameHandling.Auto,
                NullValueHandling = NullValueHandling.Ignore
            };
            return JsonConvert.SerializeObject(depandantList,settings);
        }
    }
}
