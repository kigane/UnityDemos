using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;
using UnityEngine;

namespace Demos
{
    // 指定属性的使用范围(默认为ALL)， 是否可以重复使用属性
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Struct, AllowMultiple = true)]
    public class Author : Attribute
    {
        string name;
        public double version;

        public Author(string name)
        {
            this.name = name;

            // Default value.  
            version = 1.0;
        }

        public string GetName()
        {
            return name;
        }
    }

    [Author("Joker")]
    public class FirstClass
    {
        // ...  
    }

    public class SecondClass
    {
        // ...  
    }

    // 并没有提供两个参数的构造函数啊
    // => 可以使用k=v类型的参数为自定义Attribute的public的属性赋值。
    [Author("Joker"), Author("Yui", version = 2.0)]
    public class ThirdClass
    {
        // ...  
    }

    public enum Animal
    {
        Dog = 1,
        Cat,
        Bird,
        Elephant,
        Rat,
        Pig
    }

    // [AttributeUsageAttribute(AttributeTargets.All, Inherited = true, AllowMultiple = false)]
    public class AnimalTypeAttribute : Attribute
    {
        public AnimalTypeAttribute(Animal pet)
        {
            thePet = pet;
        }

        protected Animal thePet;

        public Animal Pet
        {
            get { return thePet; }
            set { thePet = value; }
        }
    }

    [AnimalType(Animal.Elephant)]
    class AnimalTypeTestClass
    {
        [AnimalType(Animal.Pig)]
        public const string Attc = "hello";

        [AnimalType(Animal.Bird)]
        public AnimalTypeTestClass() { }

        [AnimalType(Animal.Bird)]
        public AnimalTypeTestClass(string n) { name = n; }

        [AnimalType(Animal.Rat)]
        public string name;

        [AnimalType(Animal.Cat)]
        public string Name { get => name; set => name = value; }

        [AnimalType(Animal.Dog)]
        public void DogMethod() { }
    }

    public class AttributeReflection : MonoBehaviour
    {
        private void Awake()
        {
            PrintClassAttributeInfo(typeof(FirstClass));
            PrintClassAttributeInfo(typeof(SecondClass));
            PrintClassAttributeInfo(typeof(ThirdClass));
            PrintClassAttributeInfo(typeof(AnimalTypeTestClass));
            PrintMethodAttributeInfo(typeof(AnimalTypeTestClass));
            PrintMemberAttributeInfo(typeof(AnimalTypeTestClass));
        }

        private void PrintClassAttributeInfo(Type t)
        {
            // 获取类的所有属性
            Attribute[] attrs = Attribute.GetCustomAttributes(t);

            foreach (Attribute attr in attrs)
            {
                // 查找目标属性
                if (attr.GetType() == typeof(Author))
                {
                    Author a = (Author)attr;
                    Log.Debug($"{t} has a class attribute: {a.GetName()}, version {a.version:f}");
                }

                if (attr.GetType() == typeof(AnimalTypeAttribute))
                {
                    AnimalTypeAttribute a = (AnimalTypeAttribute)attr;
                    Log.Debug($"{t} has a class attribute: {a.Pet}");
                }
            }
        }

        private void PrintMethodAttributeInfo(Type type)
        {
            // 遍历类的所有Method
            foreach (MethodInfo mInfo in type.GetMethods())
            {
                // 遍历每个Method上的所有Attribute
                foreach (Attribute attr in Attribute.GetCustomAttributes(mInfo))
                {
                    // 检查特定的Attribute类型
                    if (attr.GetType() == typeof(AnimalTypeAttribute))
                        Log.Debug($"Method {mInfo.Name} has a pet {((AnimalTypeAttribute)attr).Pet} attribute.");
                }
            }
        }

        private void PrintMemberAttributeInfo(Type type)
        {
            // 获取类的所有成员的属性
            // Member包括Method, Field, Property, Constant, Ctor
            foreach (MemberInfo mInfo in type.GetMembers())
            {
                // 遍历每个Member的所有Attribute
                foreach (Attribute attr in Attribute.GetCustomAttributes(mInfo))
                {
                    // 检查特定的Attribute类型
                    if (attr.GetType() == typeof(AnimalTypeAttribute))
                        Log.Debug($"Member {mInfo.Name} has a pet {((AnimalTypeAttribute)attr).Pet} attribute.");
                }
            }
        }
    }
}
