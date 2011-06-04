using System;
using System.Collections.Generic;
using System.Text;

namespace INovelEngine.Effector.Graphics.Text
{
    class IndexedLinkedList<T>
    {

        LinkedList<T> data = new LinkedList<T>();
        Dictionary<T, LinkedListNode<T>> index = new Dictionary<T, LinkedListNode<T>>();

        public void Add(T value)
        {
            index[value] = data.AddLast(value);
        }

        public void RemoveFirst()
        {
            index.Remove(data.First.Value);
            data.RemoveFirst();
        }

        public void Remove(T value)
        {
            LinkedListNode<T> node;
            if (index.TryGetValue(value, out node))
            {
                data.Remove(node);
                index.Remove(value);
            }
        }

        public int Count
        {
            get
            {
                return data.Count;
            }
        }

        public void Clear()
        {
            data.Clear();
            index.Clear();
        }

        public T First
        {
            get
            {
                return data.First.Value;
            }
        }
    }

    class CachedDictionary<K,T> : IDisposable
    { 
        public delegate void FreeCall(T target);

        private IndexedLinkedList<K> keyList;
        private Dictionary<K, T> data;

        private int _cacheSize;
        private FreeCall _call;

        public CachedDictionary(int cacheSize, FreeCall call)
        {
            if (cacheSize < 1)
            {
                throw new ApplicationException("Invalid cache size");
            }

            _cacheSize = cacheSize;

            keyList = new IndexedLinkedList<K>();
            data = new Dictionary<K, T>();

            if (call != null)
            {
                _call = call;
            }
            else
            {
                _call = null;
            }
        }

        public CachedDictionary(int cacheSize) : this(cacheSize, null)
        {
        }

        public T this[K key]
        {
            get
            {
                T result = data[key];
                keyList.Remove(key);
                keyList.Add(key);
                return result;
            }
        }

        public int Count
        {
            get
            {
                return data.Count;
            }
        }

        public System.Collections.Generic.Dictionary<K, T>.KeyCollection Keys
        {
            get
            {
                return data.Keys;
            }
        }

        public bool ContainsKey(K key)
        {
            return data.ContainsKey(key);
        }

        public void Add(K key, T value)
        {
            this.keyList.Add(key);
            data.Add(key, value);

            if (data.Count > this._cacheSize)
            {
                K discardingKey = this.keyList.First;
                if (this._call != null)
                {
                    _call(data[discardingKey]);
                }
                data.Remove(discardingKey);
                this.keyList.RemoveFirst();
            }
        }

        public bool Remove(K key)
        {
            bool removed = data.ContainsKey(key);
            if (removed)
            {
                if (this._call != null)
                {
                    _call(data[key]);
                }
                data.Remove(key);
                keyList.Remove(key);
            }
            return removed;
        }

        #region IDisposable Members

        public void Dispose()
        {
            if (_call != null)
            {
                foreach (T value in data.Values)
                {
                    _call(value);
                }
            }
        }

        #endregion
    }
}
