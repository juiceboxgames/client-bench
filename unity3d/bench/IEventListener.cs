using System;

namespace AssemblyCSharp
{
	public interface IEventListener
	{
	    bool HandleEvent(IEvent evt);
	}
}

