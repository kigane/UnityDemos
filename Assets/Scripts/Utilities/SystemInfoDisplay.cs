using System;
using System.Reflection;
using UnityEngine;

namespace Demos
{
    public class SystemInfoDisplay : MonoBehaviour
    {
        private void Start()
        {
            Type type = typeof(SystemInfo);
            // 获取类的所有成员的属性
            // Member包括Method, Field, Property, Constant, Ctor
            foreach (MemberInfo mInfo in type.GetMembers())
            {
                Log.Debug(mInfo.Name);
                // Log.Info(mInfo.ToString());
            }

            foreach (PropertyInfo pInfo in type.GetProperties())
            {
                Log.Info(pInfo.Name, pInfo.GetValue(type), 14);
                // Log.Info(mInfo.ToString());
            }
        }
    }
}
