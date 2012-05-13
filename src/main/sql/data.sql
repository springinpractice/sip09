use sip09;

insert into comment_target values (1, now(), null);

insert into article values (1, 'concurrent-programming', 'Software Development', 'Concurrent Programming for Practicing Software Engineers', 'Willie Wheeler',
    'Learn several concurrent programming concepts that every professional software engineer needs to understand.',
    'This article covers several important concurrent programming concepts that every professional software engineer needs to understand: serialism, parallelism, race conditions, synchronization, deadlocks and global lock orderings.',
    'threads,multithreading,concurrency,concurrent programming,parallelism,synchronization,locks,mutex,deadlocks,race conditions,data races,atomic,atomicity,synchronized,deadlock,global lock order,java,j2ee,jee,java threads,java concurrent programming,concurrent programming in java',
    1, '2008-10-13', null);

insert into article_page values (1, 1, 1, 'Concurrent Programming for Practicing Software Engineers', null, null,
'<div style="float:right;margin:0 0 10px 10px"><div class="photo"><img alt="shaggy359" src="http://wheelersoftware.s3.amazonaws.com/articles/concurrent-programming/race.jpg" class="photo"></div><div class="photoCaption">Photo credit: <a href="http://www.flickr.com/photos/12495774@N02/2405297371/">shaggy359</a> </div></div>

<p><span class="dropcap">M</span>any professional software engineers see
concurrent programming as something of an arcane art, and indeed it''s possible
to make it several years into a career without a good grasp of threads.  The
reasons seem clear enough:</p>

<ul>

<li>Most problems don''t require a strong understanding of concurrency. I''d even
argue that many web applications, which are often <em>highly</em> concurrent,
don''t require a strong understanding of concurrency: sometimes there isn''t
significant data sharing; sometimes the burden of managing concurrency,
isolation and deadlocks is pushed back to a transactional data store; sometimes
the consequences of races are minor or completely insignificant; etc.</li>

<li>Even when a problem does require some knowledge of concurrency, a lack of
knowledge manifests itself only sporadically and generally in ways that are
difficult to reproduce, which allows people to mistake their 99.9999% solution for a 100%
solution. Even in cases where the developer is under no such delusion, he may
believe that his 99.9999% solution "works". He fails to notice that 99.9999% may
not be so high when you''re talking about long-running applications running on
processors that execute billions of cycles per second, and that sometimes the
consequences of that 1-in-1,000,000 screwup are
<a href="http://en.wikipedia.org/wiki/Therac-25">disastrous</a>.</li>

<li>The "behavioral" structure of a program, as embodied by its threads, is
largely orthogonal to the program''s "static" structure, as embodied by packages,
classes and methods. Since code is organized around the latter, developers can
"see" and understand it. Since code is not organized around the behavioral
structure (for example, the code does not contain explicit representations of
the paths of individual threads), developers have a harder time seeing and
understanding it.</li>

</ul>

<p>There are times when you really do need to understand how threads work in
order to implement required functionality or else
<a href="http://wheelersoftware.com/articles/mentoring-software-developers.html">avoid simple but potentially
serious mistakes</a>.</p>

<h3>What we''ll cover</h3>

<p>In this article we''re going to cover several important concurrent programming
concepts that every professional software developer needs to understand:
serialism, parallelism, race conditions, synchronization, deadlocks and global
lock orderings. The concepts form a logical progression that looks a little like
an arms race: some problems lend themselves to a parallel solution, but
parallelism gives rise to race conditions. We counter race conditions with
synchronization (among other techniques), but synchronization leads to deadlocks
(among other problems). And so we counter deadlocks with global lock orderings
(among other techniques).</p>

<p>You''ll note that I said "among other problems" and "among other techniques".
The treatment here doesn''t pretend to be comprehensive. There are lots of
important topics in concurrent programming, such as proper encapsulation,
contention-induced (rather than compute-induced) performance issues, read/write
locking, minimizing lock scope, fine- vs. coarse-grained locks, timeouts,
forking and joining and on and on (and on). I believe however that the topics
we''re about to treat provide a nice context against which developers can more
easily learn other topics. I''ll probably write about some of the other topics
eventually.</p>

<p>By the end of the article you''ll have a basic foundation in
multithreaded programming, one that I consider to be required for
practicing software engineers.</p>

<p>Our presentation is Java-centric, but developers from other languages
(especially C#) should still find the discussion useful.</p>');

insert into article_page values (2, 1, 2, 'Serialism, Parallelism, or What is a Thread', null, null,
'<h2>What is a thread?</h2>

<p>Let''s begin by introducing the star of the show, the thread. The following
is probably more accurately considered a description rather than a definition,
even though it reads a little like the latter.</p>

<p>A thread is a sequential flow of control with its own program counter and
call stack. It shares state, memory and resources with other threads in
the same process. Since each thread gets its own call stack, local variables aren''t
shared. Instance and class variables, however, are shared across threads. It''s
also possible to define variables that exist outside of methods but are still
local to a specific thread, and these are called
<a href="http://en.wikipedia.org/wiki/Thread-local_storage">thread-local</a>
variables.</p>

<p>OK, so that''s what a thread is. What can we do with them?</p>

<h2>Serialism and parallelism</h2>

<p>In software development we''re asked to solve different kinds of problem. We
may be asked to write code that takes a bunch of information about a loan
applicant and produces a verdict as to whether that applicant should get the
loan. Maybe we have to write a web-based shopping cart. Or maybe we have to
write code to make a guy''s arms and legs flail about in a realistic fashion
when he falls off a cliff in a video game.</p>

<p>For any given problem there are typically multiple ways to solve it, and
different ways to categorize the solutions. One useful way of distinguishing
solutions is to separate <em>serial</em> from <em>parallel</em> solutions.
Let''s look at that distinction in more detail.</p>

<h3>Serial approaches to solving problems</h3>

<p>Some problems have solutions that are essentially a single series
of steps. If you''re writing a home affordability calculator, for
example, the steps might be as follows:</p>

<ol>

<li>Collect data from the user, such as their annual salary, the
amount of the down payment, their monthly bill payments,
whatever.</li>

<li>Crunch some numbers.</li>

<li>Show the maximum dollar amount the user can afford and an ad for a
local Realtor.</li>

</ol>

<p>Our recipe for solving the "home affordability problem" is said to be
<em>serial</em> because it''s essentially just a series of steps to carry out.
We might even go so far as to describing the problem itself as a serial problem,
which is just a shorthand way of saying that the most plausible and reasonable
solutions to the problem are serial solutions. Either way, the essence of
serialism is that we have a series of steps that a single control flow can
carry out.</p>

<p>Now let''s look at the alternative to serialism, which would be parallelism.</p>

<div style="float:right;margin:10px 0 10px 10px">
	<div><img class="photo" src="http://wheelersoftware.s3.amazonaws.com/articles/concurrent-programming/darth-v-cat.jpg" width="300" height="300" alt="kevindooley" /></div>
	<div class="photoCaption">
		Photo credit: <a href="http://www.flickr.com/photos/pagedooley/2172001078/">kevindooley</a> 
	</div>
</div>

<h3>Parallel approaches to solving problems</h3>

<p>Some problems are amenable to solutions involving multiple concurrent
control flows, which is to say that they have <em>parallel</em> solutions. To
take a non-computing example, say you have a room with toys scattered all over
the floor. You want the room clean. As potential participants to the cleanup
effort you have yourself and three kids. A possibly-relevant piece of
background information is that one child is entirely responsible for the mess.</p>

<p>Readers with young children will no doubt recognize this classic problem from
the field of parenting algorithms. Fortunately, well-known serial and parallel
solutions are available. The best approach in any given case depends strongly
upon your goals:</p>

<ol>

<li>If you''re trying to emphasize fairness and personal responsibility, you
might opt for the obvious serial solution even though it''s slower. (In reality
this isn''t a serial solution; it inevitably involves close supervisory
involvement by a supervisory parent thread. We can ignore that detail.)</li>

<li>If you''re in a big hurry because you need to get the kids off to school,
you might choose the obvious parallel solution, despite the unfairness.</li>

<li>If you''re in an even bigger hurry you might choose the "other" serial
solution. (Hint: it doesn''t involve any kids.)</li>

</ol>

<p>Whether we''re talking about serialism or parallelism, there is a recurring
concept, which is that of a flow of control. In the serial case we have exactly
one flow. In the parallel case we have more.</p>

<p>Computer scientists, hardware engineers and software engineers spend a lot
of time with the distinction between serialism and parallelism. Let''s look at
why that is.</p>

<h3>Serialism vs. parallelism: why do we care?</h3>

<p>In a word, performance. In many cases&mdash;not all, but many&mdash;parallel
solutions are simply faster than serial solutions, owing to the "many hands make
light work" effect. And from a practical perspective, that''s the main reason we
care about concurrency (i.e., parallelism) despite its many attendant complications.</p>

<p>The rest of this article explains what some of those complications are and
some ways to overcome them.</p>');

insert into article_page values (3, 1, 3, 'How Parallelism Gives Rise to Race Conditions', null, null,
'<h2>How parallelism gives rise to race conditions</h2>

<p>Even among parallelizable problems, some are harder than others. The easy
ones are the ones that don''t involve threads sharing state with one another.
For example, if you have five independent work queues, and the goal is simply
to process all the tasks in all the queues, then there''s nothing especially
tough about this. You start five threads, run them against the five queues,
and then move on once they''re done.</p>

<p>The trickier problems are the ones that involve threads sharing state with
one another. Let''s see why.</p>

<h3>Threads and shared state</h3>

<p>Shared state presents a challenge in concurrent programming because threads
can interfere with one another if their access to that shared state isn''t
properly coordinated. If you''ve ever tried to collaborate with other authors on
a single document, you might have some experience with this problem. (Though
Google Docs does a nice job of supporting multiple simultaneous authors.) You
make some changes to the document, hoping that your coauthor didn''t make his own
changes to the part that you worked on. If he did, then there may be a mess to
clean up.</p>

<p>The essence of the problem is that at least one guy is updating the document
while somebody else is either reading it or writing it. We talked about the case
where you have two authors writing to the document, but it can be one guy
writing and someone else reading. If one person is in the middle of updating
emergency information for hurricane evacuees and another person reads a
partial update, the result could be dangerous.</p>

<p>Note that there''s no problem if you have a bunch of people simply
<em>reading</em> a document at the same time. The problem only comes up if at
least one of them is <em>writing</em> to it.</p>

<p>The problem we''ve just described is called a <em>race condition</em>. The
idea is that if threads aren''t properly coordinated, then their concurrent work
is vulnerable to problems associated with "unlucky timing". There can be
situations in which one thread is trying to update shared state and one or more
other threads are trying to access it (either read or write). In effect the
threads "race" against one another and the outcome of their work is dependent
on the nondeterministic outcome of their race.</p>

<p>Let''s look at a code example.</p>

<h3>An example of code that allows race conditions</h3>

<p>Originally I was going to present the standard (and probably a bit tired) web
page hit counter example. But then today I saw somebody''s purportedly threadsafe
class that is in fact susceptible to race conditions. The code was written by an
experienced engineer. So let''s use that example instead, shown in Listing 1
below, as it''s instructive.</p>

<div>
<div><span class="code-listing">Listing 1.</span> A class that''s supposed to be threadsafe, but isn''t</div>
<pre name="code" class="java">
public class InMemoryUserDao implements UserDao {
	private Map&lt;String, User&gt; users;

	public InMemoryUserDao() {
		users = Collections.synchronizedMap(new HashMap&lt;String, User&gt;());
	}

	public boolean userExists(String username) {
		return users.containsKey(username);
	}

	public void createUser(User user) {
		String username = user.getUsername();
		if (userExists(username)) {
			throw new DuplicateUserException();
		}
		users.put(username, user);
	}

	public User findUser(String username) {
		User user = users.get(username);
		if (user == null) {
			throw new NoSuchUserException();
		}
		return user;
	}

	public void updateUser(User user) {
		String username = user.getUsername();
		if (!userExists(username)) {
			throw new NoSuchUserException();
		}
		users.put(username, user);
	}

	public void removeUser(String username) {
		if (!userExists(username)) {
			throw new NoSuchUserException();
		}
		users.remove(username);
	}
}
</pre>
</div>

<p>What do you think? See anything? The engineer claims that the class
is threadsafe because we''ve wrapped our hashmap with a synchronized
instance.</p>

<h3>Threadsafety problems with the code</h3>

<p>It turns out that that''s not correct. It''s a common misconception
that as long as you''re dealing with a threadsafe collection (like a
synchronized map), you''ve taken care of any threadsafety issues you
might have otherwise had. We''ll use this example to show why this
belief is just plain wrong.</p>

<p>Before I expose the race conditions, let me state some plausible
assumptions about the intended semantics for the class:</p>

<ul>

<li>Calling <code>createUser()</code> with an user whose username
already exists in the map should generate
a <code>DuplicateUserException</code>.</li>

<li>Calling <code>updateUser()</code> with an user whose username does
not already exist should generate
a <code>NoSuchUserException</code>.</li>

<li>Calling <code>removeUser()</code> with an user whose username does
not already exist should generate
a <code>NoSuchUserException</code>.</li>

</ul>

<p>Now let''s see how the implementation fails to support those
semantics, and in particular how the implementation permits race
conditions.</p>

<p><b>createUser() is broken.</b> Here''s a race that
shows that <code>createUser()</code> does not have the intended
semantics:</p>

<ol>

<li>Thread T<sub>1</sub> enters <code>createUser()</code>, with argument user U<sub>1</sub>
having username N. N is not already in the map.</li>

<li>Thread T<sub>1</sub> successfully makes it past the <code>if</code> test, but
not yet to the line that puts N in the map.</li>

<li>Context switch to thread T<sub>2</sub>, which also
enters <code>createUser()</code>, this time with argument user U<sub>2</sub>
having the same username N that U<sub>1</sub> has. (You can imagine, for example,
two users registering with the same username at the same time.) N is
still not in the map, because thread T<sub>1</sub> hasn''t put it there yet.</li>

<li>Thread T<sub>2</sub> completes its call to <code>createUser()</code> and
exits. User U<sub>2</sub> and username N are now in the map.</li>

<li>Thread T<sub>1</sub> completes the method and executes. User U<sub>1</sub> has been
placed into the map under the key N.</li>

</ol>

<p>Poof! User U<sub>2</sub> simply disappears from the map, having been
overwritten by user U<sub>1</sub>. T<sub>1</sub> never encounters the
<code>DuplicateUserException</code> it''s supposed to encounter.</p>

<p><b>updateUser() is broken.</b> This one is a little more subtle than the
<code>createUser()</code> case. Here''s the race:</p>

<ol>

<li>Thread T<sub>1</sub> enters <code>updateUser()</code> with user U having name
N. The user already exists in the map, so T<sub>1</sub> passes
the <code>if</code> test successfully. It hasn''t reached
the <code>put()</code> part yet.</li>

<li>Context switch to thread T<sub>2</sub>, which enters and
exits <code>removeUser()</code> with username N (the same one that T<sub>1</sub>
was using). The user U is removed from the map.</li>

<li>Thread T<sub>1</sub> completes, placing U back in the map under key N. User U
has essentially been reinstated.</li>

</ol>

<p>The problem here is that the <code>removeUser()</code> method
completed successfully, there was no <code>createUser()</code> call,
and yet there''s still a user sitting in the map with no error having
been thrown. Given the semantics described above, that should not be
possible. The only two possible outcomes ought to be: (1) the update
occurs before the remove, which would mean that when the two threads
complete, U is no longer in the map; or (2) the remove occurs before
the update, which would mean that U should be gone, and the update
should have generated an exception. In either case, U should not be in
the map when the two threads complete, and yet there it is. So if T<sub>2</sub>
belongs to an admin who thought he was removing a troublesome user,
guess again.</p>

<p><b>removeUser() is broken.</b> We''ve already seen in the race above that
there are situations under which <code>removeUser()</code> would be expected to
remove a user but does not actually do that. Here''s another race for you,
probably less significant, but still a bug:</p>

<ol>

<li>Thread T<sub>1</sub> enters <code>removeUser()</code> with existing username
N, and makes it past the <code>if</code> test.</li>

<li>Context switch to thread T<sub>2</sub>, which enters and
exits <code>removeUser()</code> with the same username N.</li>

<li>Thread T<sub>1</sub> completes and exits the method.</li>

</ol>

<p>In this case we have two methods that called
the <code>removeUser()</code> method with the same username, but
neither thread encountered a <code>NoSuchUserException</code>. That is
not compatible with the semantics of the class.</p>

<p>Now that we''ve seen some problems, let''s try to understand what''s
happening here.</p>

<h3>What the three broken methods have in common</h3>

<p>One thing that all three cases have in common is that they follow a
"check-then-act" pattern, where both the "check" and "act" parts
reference shared data (in this case, the
hashmap). The <code>createUser()</code> method checks whether the
username already exists, and if not, adds the user to the
map. The <code>updateUser()</code> method checks whether the username
already exists, and if so, updates the
user. <code>removeUser()</code> checks whether the username exists, and if so,
deletes the user.</p>

<p>Note that the <code>findUser()</code> method does <em>not</em>
follow the same pattern. It does a single <code>get()</code> against
the map, and then does a check that checks the returned user rather
than checking something against the map. Though it looks like almost
the same thing, it is really a completely different situation because
we''re performing only one action against the shared data instead of
multiple actions.</p>

<p>It turns out that the difference between <code>createUser()</code>,
<code>updateUser()</code> and <code>removeUser()</code>, on the one hand, and
the <code>findUser()</code> method, on the other, is important from a threadsafety
point of view. Essentially what''s happening is that the <code>findUser()</code>
method is <em>atomic</em> (with a certain qualification, which we''ll discuss in
the next section), meaning that it executes as a single action. The
<code>createUser()</code>, <code>updateUser()</code> and <code>removeUser()</code>
methods, on the other hand, are not atomic. The various check and act operations
can be interleaved in arbitrary ways across different threads. Intuitively what
that means is that checks, which are supposed to provide safety, can become
invalid because other actions can be scheduled in between any given check-act pair.
The safety checks are invalidated and the class behaves in strange ways (especially
as load increases, which is usually the most inopportune time for such issues to
arise).</p>

<p>Now let''s look at how we can solve race conditions such as the ones we''ve been
considering.</p>');

insert into article_page values (4, 1, 4, 'Solving Race Conditions with Synchronization', null, null,
'<h2>Solving race conditions with synchronization</h2>

<p>The key to avoiding race conditions is to coordinate the multiple threads
when accessing shared data. There are different ways to do this, but the simplest
is the one your mom taught you when you were a kid: take turns.</p>

<h3>Taking turns with mutexes</h3>

<p>Here''s how you take turns in software. Suppose that you have some shared
data that you want to protect, such as a list of all the posts in a given
web-based discussion forum, or a web page hit counter. You have various blocks
of code throughout your application that access that data, both reading it and
writing it. These blocks of code don''t have to be in the same class (though
they often are), but they''re all accessing the same data.</p>

<p>(Keep in mind that when we describe the data as shared data, we mean that it''s
shared by multiple threads, not that multiple blocks of code access it. If
multiple blocks of code access the data but only one thread ever does, then it''s
not shared data.)</p>

<p>The trick is to protect the code so that only one thread can enter it at a
time. I don''t mean that only one thread can enter one of the code blocks at a
time. I mean that if you consider the whole set of code blocks as a single
group, only one thread can enter that group at a time. So if one thread enters
one of the blocks, then all other threads need to be kept out of all other
blocks until that first thread is done.</p>

<p>The way we enforce this behavior is to associate with each block of code you
want to protect something called a mutual exclusion lock, or <em>mutex</em>.
People often just call it a lock as well. You associate a lock with any given
piece of data you want to protect, and all the code blocks that access that data
use that same lock. A thread is not allowed to enter the code block unless it
acquires the lock. So whenever thread T<sub>1</sub> wants to enter, it attempts
to grab the lock. If the lock is available, then T<sub>1</sub> takes it and
other threads have to wait until T<sub>1</sub> is done. If instead some other
thread T<sub>2</sub> has the lock, then T<sub>1</sub> has to wait until
T<sub>2</sub> is done.</p>

<p>When a thread leaves the block of code protected by the mutex, known as the
<em>critical section</em>, it releases the lock.</p>

<p>Incidentally, I always thought it was kind of funny we talk about grabbing
locks. It seems like we should say we grab a key so we can get past the lock.
But that''s not how people talk about it.</p>

<p>We now introduce the principal way of implementing a mutex in Java, the
<code>synchronized</code> keyword.</p>

<h3>The <code>synchronized</code> keyword</h3>

<p>In Java the primary mechanism for enforcing turn-taking across threads is
the <code>synchronized</code> keyword. You basically put the code you want to
protect inside a <code>synchronized</code> block, specifying a lock object (or
more exactly, specifying an object whose <em>monitor</em> will be used as a
lock&mdash;in Java, each object has a "monitor" that can be used as a mutex).
If you want to synchronize access to the whole method, you just use the
<code>synchronized</code> keyword on the method itself. In this latter case, the
locking object is the one on which the method is being called.</p>

<p>Here''s an example of a synchronized block:</p>

<pre name="code" class="java">
synchronized (myList) {
	int lastIndex = myList.size() - 1;
	myList.remove(lastIndex);
}
</pre>

<p>Here, we''re using the <code>myList</code> instance as the lock. Anytime a
thread wants to enter this block of code, or any other block of code protected
by the same lock, it needs to grab the lock on the <code>myList</code>
instance first. And it releases the lock upon exiting the <code>synchronized</code>
block (i.e., the critical section).</p>

<p>Here''s an example of a synchronized method:</p>

<pre name="code" class="java">
public class Order {

	...

	public synchronized void removeLastLineItem() {
		int lastIndex = myList.size() - 1;
		myList.remove(lastIndex);
	}
}
</pre>

<p>In this case, a thread wanting to enter the <code>removeLastLineItem()</code>
method would need to grab the lock on the relevant <code>Order</code>
instance first, and would release the lock after exiting the method.</p> 

<p>Armed with our understanding of mutexes and the <code>synchronized</code>
keyword, let''s revisit our example from the previous page.</p>

<h3>Our example, revisited: making the code threadsafe</h3>

<p>Listing 2 shows how to apply thread synchronization to make the class
threadsafe.</p>

<div>
<div><span class="code-listing">Listing 2.</span> A threadsafe version of our DAO</div>
<pre name="code" class="java">
public final class InMemoryUserDao implements UserDao {
	private Map&lt;String, User&gt; users;

	public InMemoryUserDao() {
		users = Collections.synchronizedMap(new HashMap&lt;String, User&gt;());
	}

	public boolean userExists(String username) {
		return users.containsKey(username);
	}

	public void createUser(User user) {
		String username = user.getUsername();
		synchronized (users) {
			if (userExists(username)) {
				throw new DuplicateUserException();
			}
			users.put(username, user);
		}
	}

	public User findUser(String username) {
		User user = users.get(username);
		if (user == null) {
			throw new NoSuchUserException();
		}
		return user;
	}

	public void updateUser(User user) {
		String username = user.getUsername();
		synchronized (users) {
			if (!userExists(username)) {
				throw new NoSuchUserException();
			}
			users.put(username, user);
		}
	}

	public void removeUser(String username) {
		synchronized (users) {
			if (!userExists(username)) {
				throw new NoSuchUserException();
			}
			users.remove(username);
		}
	}
}
</pre>
</div>

<p>In Listing 2 we''ve addressed the three issues that we raised earlier. First
note that the <code>users</code> instance is entirely encapsulated by our
<code>InMemoryUserDao</code> class (I''ve made the class <code>final</code> to
prevent inheritance from breaking our encapsulation here), so that means it
is entirely within our power to protect every possible access to the
<code>users</code> instance. (Hm, that''s probably a good interview question:
"Discuss the relationship between encapsulation and threadsafety.")</p>

<p>Next note that we''ve addressed the general problem that we saw by making
every "check-then-act" occurrence atomic. Now the code is such that if thread
T checks something (such as checking whether a username exists), we can be sure
that the answer doesn''t change before the action part, because no other thread
is able to access the <code>users</code> instance at all until T is done with
it.</p>

<h3>Internal vs. external synchronization</h3>

<p>There''s one detail to discuss. Take a look at the <code>userExists()</code>
and <code>findUser()</code> methods. In both cases we access the
<code>users</code> instance, but there''s no <code>synchronized</code> block.
The reason this isn''t a problem is that both of the following are true:</p>

<ol>
<li>we''re calling only one method on the <code>users</code> map, and</li>
<li>the map is internally synchronized since we created the map using the
<code>Collections.synchronizedMap(...)</code> wrapper.</li>
</ol>

<p>If either of those two conditions had failed, we''d need to put the calls in a
<code>synchronized</code> block. It''s useful to discuss these a little more
carefully.</p>

<p>Let''s take (1) first. Note that even though we don''t have an explicit
<code>synchronized</code> block, each individual method call we make against
<code>users</code> is threadsafe. That''s because the <code>users</code> map is
internally synchronized on the monitor for the <code>users</code> instance
itself. That is, the map handles synchronization for individual method calls
so we don''t have to. If we''re just going to call a single method on an internally
synchronized method, we''re usually OK to do so.</p>

<p>The place where we have to pay attention to threadsafety is where we call
multiple methods on the <code>users</code> instance. There, the internal
synchronization doesn''t help us at all because that synchronization doesn''t
prevent the thread from releasing the lock in between the multiple method calls.
And when it releases the lock, another thread can come in and change the data.
If your code logic assumes that the multiple method calls behave as an atomic
unit, you have a problem. Therefore you must provide your own synchronization
on the relevant lock when you use check-then-act and similar patterns.</p>

<p>It is a common error to assume that just because the object is internally
synchronized, you don''t have to worry about threadsafety anymore. That is simply
not true, as we''ve just explained.</p>

<p>Now take (2). Clearly if the map didn''t have any internal synchronization,
then we''d need to provide it ourselves, even for single method calls against
the map. Otherwise threads could get in and muck things up for other threads.
This is true even in many cases where it <em>looks</em> like individual
threads are performing atomic actions. For example, if you have some threads
making <code>get()</code> calls against a <code>HashMap</code>, and another
set of threads making <code>put()</code> calls against the same <code>HashMap</code>,
you may think that they are all performing atomic operations and therefore it''s
OK to do this. But that is not correct. The problem is that they only <em>look</em>
like atomic operations; behind the scenes, they''re impacting the size of a shared
backing array, which in turn impacts how hashcodes are mapped to buckets, which impacts
the <code>get()</code> and <code>put()</code> calls themselves. If the class had
internal synchronization then <code>get()</code> and <code>put()</code> would
both be atomic from the perspective of external code, but without that, they
aren''t atomic at all.</p>

<p>That was your crash course on solving race conditions with thread
synchronization. It''s not a simple topic, but you should now have the basics.
But even though thread synchronization helps solve one problem, unfortunately
it creates another. The problem is that in forcing threads to stop and wait
their turn, you create the potential for the situation in which threads might
wait indefinitely before they can move on. This is called a deadlock, and it''s
the subject of the next section.</p>');

insert into article_page values (5, 1, 5, 'How Synchronization Gives Rise to Deadlocks', null, null,
'<h2>How synchronization gives rise to deadlocks</h2>

<p>We saw in the previous section how a thread will grab a lock just before
entering a critical section, thereby forcing other threads to "block" (concurrency
lingo for "wait for another thread to release a lock") until they can acquire the
lock. Normally this blocking behavior is unremarkable. It is a standard part of
concurrent programming since we''re trying to protect data from data races.</p>

<p>If there''s too much contention for locks, that can of course have a negative
effect on performance since threads are sitting around waiting instead of doing
work. But usually this just means subpar performance rather than hanging.</p>

<p>The pathological case of contention for locks is <em>deadlocking</em>. This
is characterized by two or more threads becoming permanently hung. They are
notoriously difficult to predict, avoid and handle, but it''s not impossible. The
secret to understanding deadlocks is to understand that they arise when threads
wait for each other to release a lock in a cyclic fashion. The simplest case
would be thread T<sub>1</sub> waiting for T<sub>2</sub> to release a lock, and
T<sub>2</sub> waiting for T<sub>1</sub> to release a lock. Neither one can make
forward progress. The next simplest case is T<sub>1</sub> waiting for T<sub>2</sub>,
T<sub>2</sub> waiting for T<sub>3</sub>, and T<sub>3</sub> waiting for T<sub>1</sub>.
Now we have three deadlocked threads. Obviously the cycle can be of arbitrary length;
all threads involved will be deadlocked.</p>

<p>Here''s a diagram that shows how it works:</p>

<div style="margin:20px auto;width:584px;">
	<div><img src="http://wheelersoftware.s3.amazonaws.com/articles/concurrent-programming/deadlocks.jpg" alt="The cyclic nature of deadlocks" /></div>
	<div class="caption"><span class="figure-label">Figure 1.</span> Deadlocks arise from circular dependencies between threads.</div>
</div>

<p>In figure 1, you can see that each thread holds the lock needed by the preceding
thread. As the dependencies are circular, there is no way for any of the threads to
make forward progress once something like the above happens. All five threads are
hung&mdash;that is, deadlocked.</p>

<div style="margin-right:10px;float:left">
	<div class="photo"><img src="http://wheelersoftware.s3.amazonaws.com/articles/concurrent-programming/vambrace-m16.jpg" alt="" /></div>
	<div class="photoCaption" style="text-align:center">
		Photo credit: <a href="http://www.flickr.com/photos/gladius/2296372699/">gladius</a> 
	</div>
</div>

<h3>A furry aside</h3>

<p>By now you might understand what I meant at the beginning of the article when
I said that concurrent programming is kind of like an arms race. We start with
single threads, but sometimes that''s too slow, so we introduce multithreading.
That causes a problem though, which is that the threads can interfere with one another
when working with shared data. So we introduce turn-taking through mutexes (and
through the <code>synchronized</code> keyword in particular). But that has the effect
of limiting parallelism, and if we take that too far, we can end up sacrificing the
parallelism (and performance) that we sought in the first place. In the most extreme
case, we can inadvertently cause threads to deadlock.</p>

<p>(Maybe <a href="http://en.wikipedia.org/wiki/Whac-a-mole">Whac-A-Mole</a> is
a better metaphor. That''s OK. I''m going to stick with arms race just because I
really like the mech/cyber photo. Think of it as an arms race between software
engineers and small furry rodents.)</p>

<div style="clear:both"></div>

<p>Now let''s consider an example of code vulnerable to deadlocks.</p>

<h3>Some deadlocky code</h3>

<p>For this one we''re going to use the standard bank account funds transfer
example. Yes, it''s a clich�d example, but it''s such a good example and originality
is overrated anyway. Here''s listing 3:</p>

<div>
<div><span class="code-listing">Listing 3.</span> A deadlock just waiting to happen</div>
<pre name="code" class="java">
public void transferFunds(Account from, Account to, Money amount) {
	synchronized (from) {
		synchronized (to) {
			from.decreaseBy(amount);
			to.increaseBy(amount);
		}
	}
}
</pre>
</div>

<p>(We''ll ignore exceptional conditions such as insufficient funds. Or, if you
like, assume that <code>decreaseBy()</code> throws an unchecked
<code>InsufficientFundsException</code>.)</p>

<p>If it isn''t obvious, the method is a service method that transfers funds
from one account to another account. Before going further, take a look at the
code and see if you can figure out how the deadlock can occur. Keep in mind
what we said about cyclic dependencies.</p>

<h3>Here''s how a deadlock can occur</h3>

<p>Recall from the discussion above that deadlocks involve multiple threads. Each
one grabs a lock that one of the other threads needs, and needs a lock that one
of the other threads has. Here, we have two <code>synchronized</code> blocks,
and each entry point corresponds to a place where a thread will try to grab a
lock, maybe successfully and maybe not.</p>

<p>With that information it''s straightforward to construct the sequence of events
that leads to the deadlock:</p>

<ol>
	<li>Thread T<sub>1</sub> enters the method, with the source account being
	account 4 and the destination account being account 14. T<sub>1</sub> is
	able to acquire the lock for account 4, but then there''s a context switch
	before it can enter the second <code>synchronized</code> block.</li>
	
	<li>Thread T<sub>2</sub> also enters the method, with the source account
	being account 14 and the destination account being account 4. T<sub>2</sub>
	is able to acquire the lock for account 14, but then gets blocked when trying
	to acquire the lock for account 4. That stands to reason, since T<sub>1</sub>
	has it. Context switch.</li>
	
	<li>T<sub>1</sub> tries to grab the lock for account 14, but of course it
	can''t since T<sub>2</sub> has it. Threads T<sub>1</sub> and T<sub>2</sub>
	are now deadlocked.</li>
</ol>

<p>That''s a fairly intricate bit of logic, and developers new to concurrent
programming may wonder how in the heck they are supposed to anticipate problems
like that. They may also wonder whether this series of events is so implausible
that is just isn''t worth worrying about. To answer the second concern first,
deadlocks most certainly do occur in real code. Keep in mind that although the
situations that produce them may be implausible, the problem is that CPU clock
speeds are pretty incredible, and so things that seem implausible suddenly become
just a matter of time.</p>

<p>As to how to defend against deadlocks, we''ll look at that right now.</p>');

insert into article_page values (6, 1, 6, 'Solving Deadlocks with Global Lock Orders', null, null,
'<h2>Solving deadlocks with globally-defined lock orderings</h2>

<p>There are different ways to either minimize the likelihood of deadlocking or
else just avoid it altogether. One best practice is to minimize the scope of
your critical sections so as to decrease the time that threads hang onto locks,
and hence to decrease the likelihood of a deadlock. That however doesn''t solve
the issue; deadlocks can still occur.</p>

<p>Another technique is to avoid the sort of nested locking that we saw in the
example in the previous page. Instead of locking each account individually, we
might define a single lock that any thread must acquire before doing a transfer.
While this does indeed eliminate deadlocks, it does so at a very steep cost:
acquiring the single lock becomes a bottleneck, and limits the parallelism
we''re trying to achieve in the first place. It does not scale.</p>

<p>A third technique is to use timeouts. Under this approach, if any thread is
blocked for a sufficiently lengthy period of time, it just gives up.</p>

<p>Those are all legitimate techniques, but in this section we''ll discuss global
lock orders.</p>

<h3>What is a globally-defined lock order?</h3>

<p>Recall in our discussion of deadlocks that they arise from circular dependencies
between the threads. Any given thread depends on a resource (a lock) that the previous
thread in the ring holds. So one way to stamp out deadlocks is to define a global
ordering on the locks so that such cycles can never arise. In other words, you define
and publish rules around which locks to acquire before which other locks. This approach
requires significant discipline from developers since there isn''t any automatic way
to enforce it. It is however extremely useful since it makes deadlocks impossible.</p>

<p>Let''s see how we might apply a global lock order to the funds transfer example.</p>

<h3>The funds transfer example reconsidered</h3>

<p>At first glance you might think, "Wait a minute. The source account''s lock is
always grabbed before the destination account''s lock, so how is it possible for a
deadlock to occur?" But upon closer examination it''s clear that that''s not a correct
analysis. Whatever global lock order we define needs to translate ultimately down
to instances, not roles in a transaction. Sometimes account 4 will be the source
account, and sometimes it will be the destination account. Similarly for account
14. Whatever global lock order we define needs to handle that.</p>

<p>One straightforward way to define a lock order for our current example would be
to say that we always grab the lock for the account with the lower ID first. Listing
4 shows the new code:</p>

<div>
<div><span class="code-listing">Listing 4.</span> Applying a globally-defined lock order</div>
<pre name="code" class="java">
public void transferFunds(Account from, Account to, Money amount) {
	long fromId = from.getId();
	long toId = to.getId();
	long lowId = (fromId &lt; toId ? fromId : toId);
	long highId = (fromId &lt; toId ? toId : fromId);
	synchronized (lowId) {
		synchronized (highId) {
			from.decreaseBy(amount);
			to.increaseBy(amount);
		}
	}
}
</pre>
</div>

<p>The code above is deadlock-free, because cyclic dependencies are impossible.
Say thread T<sub>1</sub> wants to transfer funds from account 4 to account 14, and
thread T<sub>2</sub> wants to transfer funds from account 14 to account 4. Both
threads will try to grab the lock for account 4 before trying to grab the lock for
account 14. Thus it''s impossible to wait for the lock on account 4 while holding
the lock for account 14, at least as long as all code observes the same globally-defined
lock ordering that we''ve observed here. (Hence "global".)</p>

<h2>Conclusion and recommended readings</h2>

<p>In this article we looked at several key areas of concurrent programming that
(in my opinion, anyway) all practicing software developers should understand. In
my observation, when it comes to concurrency, there is a huge gap between what
typical developers <em>should</em> know and what they <em>actually</em> know, and
that causes real-world production issues on a regular basis. I wrote this article
to try to narrow that gap.</p>

<p>There are of course lots of good resources for concurrent programming. Here are
some of my favorites:</p>

<ul>

<li><a href="http://www.infoq.com/presentations/goetz-concurrency-past-present">Concurrency:
Past and Present</a>, by Brian Goetz: An entertaining presentation on
concurrency. Goetz is a well-known authority on concurrent
programming.</li>

<li><a href="http://jcip.net/">Java Concurrency in Practice</a>, by
Brian Goetz. A really great and approachable book.</li>

<li><a href="http://www.amazon.com/Concurrent-Programming-Java-TM-Principles/dp/0201310090">Concurrent
Programming in Java(TM): Design Principles and Pattern (2nd
Edition)</a>, by Doug Lea. Another great book on concurrency; probably
the standard. More academic than the Goetz book but still quite
approachable.</li>

<li><a href="http://sunnyday.mit.edu/papers/therac.pdf">The Therac-25
Accidents</a>: A classic software engineering paper on how race
conditions actually injured and killed people. The basic idea is that
the Therac-25 machine, which was designed to administer radiation to
cancer patients, was vulnerable to race conditions that occurred as
the human operator became more experienced with operating the machine
(and thus keyboarded commands more quickly). The race conditions led
to massive radiation overdoses. Long but well worth the read.</li>

</ul>');

insert into comment values (0, 1, 'Peter Veentjer', 'peter@example.com', 'http://pveentjer.wordpress.com/', '1.1.1.1', '2008-10-13 09:01:00', null,
'dummy markdown text',
'<p>Hi,</p>
<p>I like your article because you described the classic problems and solutions well. But there are some minor issues with the code:</p>
<p>1) the userMap in the InMemoryUserDao is not published safely and therefor relies on an external happens before rule to prevent reordering and visibility problems. This could lead to a NullPointerException when accessing the users reference. In most cases with constructors this is not an issue, but imho still a bad practice. It can be fixed by making users final. For more information see http://pveentjer.wordpress.com/2008/04/02/jmm-constructors-dont-have-visiblity-problems/</p>
<p>2) I understand that you are working towards a solution with the InMemoryUserDao and step by step solve the problem. But I would add the advice to less experienced readers that they should look at really concurrent structures like the ConcurrentMap. It has atomic operations for the check/act problems (like putIfAbsent) but implementations can also perform better because they use lock striping for example instead of a big lock.</p>
<p>3) Instead of using AND the internal synchronization of the SynchronizedMap AND the synchronization in the InMemoryUserDao, I would drop the SynchronizedMap completely and replace it by a standard Hashmap (make sure that all methods are going through the lock) It makes reasoning about locking easier. So if you can''t use the ConcurrentMap (e.g. a non standard datastructure) just have one location where the locking is done.</p>');

insert into comment values (0, 1, 'Willie Wheeler', 'willie.wheeler@gmail.com', 'http://wheelersoftware.com/', '1.1.1.1', '2008-10-13 22:11:30', null,
'dummy markdown text',
'@Peter: Ah, good catch re #1. Yes, declaring users final will prevent consumer threads from seeing the DAO instance half-published (object created but state not initialized) by the publisher thread. I agree with both of your other points as well. In particular, I like your #3. Concurrency semantics are communicated through documentation more than through language features and so stylistic issues become important. Thanks for the feedback. ');

-- ============================================================================
insert into comment_target values (2, now(), null);

insert into article values (2, 'wireshark-tutorial', 'Networking', 'Fifteen Minute Wireshark Tutorial', 'Willie Wheeler',
    'Troubleshoot your networked applications using the Wireshark network protocol analyzer. This gentle introduction gets you up and running in fifteen minutes or less.',
    'Troubleshoot your networked applications using the Wireshark network protocol analyzer. This tutorial gets you up and running in fifteen minutes or less.',
    'wireshark,ethereal,network,network protocol,network protocol analysis,troubleshooting,view tcp stream,tcp traffic',
    2, '2008-03-28', null);

insert into article_page values (7, 2, 1, 'Fifteen Minute Wireshark Tutorial', null, null,
'<div style="float:right;margin:0 0 10px 10px"><div class="photo"><img src="http://wheelersoftware.s3.amazonaws.com/articles/wireshark-tutorial/shark.jpg"></div><div class="photoCaption">Photo credit: <a href="http://www.flickr.com/photos/kubina/131673530/">Jeff Kubina</a></div></div>

<p><span class="dropcap">I</span>f you''ve ever wanted the fastest possible introduction to the Wireshark network protocol analyzer, today is your lucky day.  I''m going to show you how to do something useful with Wireshark in fifteen minutes, even if you''ve never used it before.</p>

<p>This tutorial is a quickstart.  It is not at all comprehensive.  But if you just want to try it out then this is for you.</p>

<p><b>Step 1.</b> <a href="http://www.wireshark.org/">Download</a> and install Wireshark.  I''m using version 0.99.8 for Windows.  The installation is completely straightforward.</p>

<p><b>Step 2.</b> Start it up.</p>

<p><b>Step 3.</b> Think of some network application running on your machine you''d like to investigate.  For this tutorial I''ll take a look at an SMTP (e-mail) session initiated by an application I wrote.  I''ll pretend I''m troubleshooting the SMTP communication and to do that I want to see what''s happening between my app and the SMTP server.  You can pick whatever you like but pick something where you know the IP address of the remote host.  For instance you might pick an HTTP communication between your machine and a remote host.  Anyway write the IP address down.</p>

<p><b>Step 4.</b> From the Wireshark menubar, choose Capture &rarr; Options.  First, pick the interface (i.e., network interface card, or NIC) you want to investigate.  Don''t press the Start button yet.</p>

<p><b>Step 5.</b> <strong>IMPORTANT: TURN <a href="http://en.wikipedia.org/wiki/Promiscuous_mode">PROMISCUOUS MODE</a> OFF!  IF YOU''RE AT WORK, YOUR NETWORK ADMINISTRATOR MAY SEE YOU RUNNING IN PROMISCUOUS MODE AND SOMEBODY MAY DECIDE TO FIRE YOU FOR THAT.</strong>  Don''t risk it, especially not for a tutorial.  Don''t press the Start button yet.</p>

<p><b>Step 6.</b> We need to create a capture filter to prevent Wireshark from capturing all network traffic going through the interface we chose in Step 4.  It is surprising just how much network traffic goes through the interface and we don''t want to see all of it.  In the text field next to the "Capture Filter" button, type <code>host &lt;ip_address&gt;</code>, substituting in the IP address you care about for the <code>&lt;ip_address&gt;</code> part.  This will create a filter that passes only that traffic either originating from or going to the specified host.</p>

<p><b>Step 7.</b> Now you can press Start.  Wireshark is now capturing any data involving the specified IP address, whether as a source or as a destination.</p>

<p><b>Step 8.</b> If you aren''t already doing so, run the application of interest.  In this case I''m going to run the SMTP client that I mentioned in Step 3.  You should see a list of packets appear in the Wireshark window.</p>

<p><b>Step 9.</b>  Let''s take a look at the SMTP session that my app had with the SMTP server.  Go to Analyze &rarr; Follow TCP Stream.  You should see the TCP stream content.  Here''s what I saw in mine.  I''ve suppressed certain parts for security reasons but you get the picture:</p>

<pre>220 [suppressed] ESMTP Sendmail 8.13.8/8.13.6; Fri, 28 Mar 2008 01:15:04 -0700
EHLO [suppressed]
250-[suppressed] Hello [suppressed], pleased to meet you
250-ENHANCEDSTATUSCODES
250-PIPELINING
250-EXPN
250-VERB
250-8BITMIME
250-SIZE 20000000
250-DSN
250-ETRN
250-AUTH LOGIN PLAIN
250-STARTTLS
250-DELIVERBY
250 HELP
AUTH LOGIN
334 VXNlcm5hbWU6
[suppressed]
334 UGFzc3dvcmQ6
[suppressed]
535 5.7.0 authentication failed</pre>

<p>The above is an SMTP-AUTH session that shows a failed authentication.  As you can imagine, this sort of visibility can be extremely useful in troubleshooting networked applications.  For instance, here I can see that my app was able to connect with the SMTP server and send my credentials, but the SMTP server rejected them.</p>

<p>That obviously just scratches the surface with respect to Wireshark''s capabilities, but that should be enough to get you started.  Have fun!</p>');
