using System;
namespace INovelEngine.Effector.Graphics.Components
{
    interface IComponentManager
    {
        void AddComponent(INovelEngine.Effector.AbstractGUIComponent component);
        INovelEngine.Effector.AbstractGUIComponent GetComponent(string id);
        void RemoveComponent(string id);
    }
}
