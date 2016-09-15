package guestbook;

import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

import java.lang.String;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@Entity
public class Greeting{
	@Parent Key<Guestbook> theBook;
	@Id public Long id;
	
    public String author_email;
    public String author_id;
    public String title;
    public String content;
    @Index public Date date;
    
    public Greeting(){
    	date = new Date();
    }

    public Greeting(String book, String title, String content) {
        this();
        if(book!=null){
        	theBook = Key.create(Guestbook.class, book);
        } else {
        	theBook = Key.create(Guestbook.class, "default");
        }
        this.content = content;
        this.title = title;
    }

    public Greeting(String book, String title, String content, String id, String email){
    	this(book, title, content);
    	author_email = email;
    	author_id = id;
    }
    
    public String formatDate(){
    	return new SimpleDateFormat("MMM FF, yyyy @ HH:mm").format(date);
    }
}