package org.loushang.internet.response;


import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.Writer;
import java.util.LinkedList;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.loushang.internet.util.io.ByteArray;
import org.loushang.internet.util.io.ByteArrayOutputStream;
import org.loushang.internet.util.io.ResponseStringBuffer;
import org.loushang.internet.util.io.StringWriter;



/**
 * 包裹<code>HttpServletResponse</code>，使之输出到内存队列中。
 * 
 * 重写response
 * 
 */
public class BufferedResponseImpl extends HttpServletResponseWrapper {
	public static final int MAX= 8192;
    private static final Log log = LogFactory.getLog(BufferedResponseImpl.class);
    private boolean buffering = true;
    private  List<ByteArrayOutputStream> bytesList;
    private  List<StringWriter> charsList;
    private ServletOutputStream stream;
    private PrintWriter streamAdapter;
    private PrintWriter writer;
    private ServletOutputStream writerAdapter;

    /**
     * 创建一个<code>BufferedResponseImpl</code>。
     * 
     * @param requestContext response所在的request context
     * @param response 原始的response
     */
    public BufferedResponseImpl( HttpServletResponse response) {
        super(response);
    }

    /**
     * 取得输出流。
     * 
     * @return response的输出流
     * @throws IOException 输入输出失败
     */
    @Override
    public ServletOutputStream getOutputStream() throws IOException {
        if (stream != null) {
            return stream;
        }

        if (writer != null) {
            // 如果getWriter方法已经被调用，则将writer转换成OutputStream
            // 这样做会增加少量额外的内存开销，但标准的servlet engine不会遇到这种情形，
            // 只有少数servlet engine需要这种做法（resin）。
            if (writerAdapter != null) {
                return writerAdapter;
            } else {
                log.debug("Attampt to getOutputStream after calling getWriter.  This may cause unnecessary system cost.");
                writerAdapter = new WriterOutputStream(writer, getCharacterEncoding());
                return writerAdapter;
            }
        }

        if (buffering) {
            // 注意，servletStream一旦创建，就不改变，
            // 如果需要改变，只需要改变其下面的bytes流即可。
            if (bytesList == null) {
                bytesList = new LinkedList<ByteArrayOutputStream>();
            }

            ByteArrayOutputStream bytes = new ByteArrayOutputStream();

            bytesList.add(bytes);
            stream = new BufferedServletOutputStream(bytes);

            log.debug("Created new byte buffer");
        } else {
            stream = super.getOutputStream();
        }

        return stream;
    }

    /**
     * 取得输出字符流。
     * 
     * @return response的输出字符流
     * @throws IOException 输入输出失败
     */
    @Override
    public PrintWriter getWriter() throws IOException {
        if (writer != null) {
            return writer;
        }

        if (stream != null) {
            // 如果getOutputStream方法已经被调用，则将stream转换成PrintWriter。
            // 这样做会增加少量额外的内存开销，但标准的servlet engine不会遇到这种情形，
            // 只有少数servlet engine需要这种做法（resin）。
            if (streamAdapter != null) {
                return streamAdapter;
            } else {
                log.debug("Attampt to getWriter after calling getOutputStream.  This may cause unnecessary system cost.");
                streamAdapter = new PrintWriter(new OutputStreamWriter(stream, getCharacterEncoding()), true);
                return streamAdapter;
            }
        }

        if (buffering) {
            // 注意，servletWriter一旦创建，就不改变，
            // 如果需要改变，只需要改变其下面的chars流即可。
            if (charsList == null) {
                charsList = new LinkedList<StringWriter>();
            }

            StringWriter chars = new StringWriter();
            
            charsList.add(chars);
            writer = new BufferedServletWriter(chars,charsList);

            log.debug("Created new character buffer");
        } else {
            writer = super.getWriter();
        }

        return writer;
    }

    /**
     * 设置content长度。该调用只在<code>setBuffering(false)</code>时有效。
     * 
     * @param length content长度
     */
    @Override
    public void setContentLength(int length) {
        if (!buffering) {
            super.setContentLength(length);
        }
    }

    /**
     * 冲洗buffer。
     * 
     * @throws IOException 如果失败
     */
    @Override
    public void flushBuffer() throws IOException {
        if (buffering) {
            flushBufferAdapter();

            if (writer != null) {
                writer.flush();
            } else if (stream != null) {
                stream.flush();
            }
        } else {
            super.flushBuffer();
        }
    }

    /**
     * 清除所有buffers，常用于显示出错信息。
     * 
     * @throws IllegalStateException 如果response已经commit
     */
    @Override
    public void resetBuffer() {
        if (buffering) {
            flushBufferAdapter();

            if (stream != null) {
                bytesList.clear();
                ByteArrayOutputStream out = new ByteArrayOutputStream();
                bytesList.add(out);
                ((BufferedServletOutputStream) stream).updateOutputStream(out);
            }

            if (writer != null) {
                charsList.clear();
                StringWriter stringwriter = new StringWriter();
                charsList.add(stringwriter);
                ((BufferedServletWriter) writer).updateWriter(stringwriter);
            }
        }

        super.resetBuffer();
    }

    /**
     * 设置是否将所有信息保存在内存中。
     * 
     * @return 如果是，则返回<code>true</code>
     */
    public boolean isBuffering() {
        return buffering;
    }

    /**
     * 设置buffer模式，如果设置成<code>true</code>，表示将所有信息保存在内存中，否则直接输出到原始response中。
     * <p>
     * 此方法必须在<code>getOutputStream</code>和<code>getWriter</code>方法之前执行，否则将抛出
     * <code>IllegalStateException</code>。
     * </p>
     * 
     * @param buffering 是否buffer内容
     * @throws IllegalStateException <code>getOutputStream</code>或
     *             <code>getWriter</code>方法已经被执行
     */
    public void setBuffering(boolean buffering) {
        if (stream == null && writer == null) {
            if (this.buffering != buffering) {
                this.buffering = buffering;
                log.debug("Set buffering " + (buffering ? "on" : "off"));
            }
        } else {
            if (this.buffering != buffering) {
                throw new IllegalStateException(
                        "Unable to change the buffering mode since the getOutputStream() or getWriter() method has been called");
            }
        }
    }

    /**
     * 将buffer队列中的内容提交到真正的servlet输出流中。
     * <p>
     * 如果从来没有执行过<code>getOutputStream</code>或<code>getWriter</code>
     * 方法，则该方法不做任何事情。
     * </p>
     * 
     * @throws IOException 如果输入输出失败
     * @throws IllegalStateException 如果不是在buffer模式
     */
    public void commitBuffer(String header) throws IOException {
        if (stream == null && writer == null) {
            return;
        }

        if (!buffering) {
            throw new IllegalStateException("Buffering mode is required for commitBuffer");
        }

        // 循环输出bytes
        if (stream != null) {         
            OutputStream ostream = super.getOutputStream();
        	ostream.write(header.getBytes());
        	flushBufferAdapter();
            for(int i =0 ;i<bytesList.size();i++){
            	ByteArrayOutputStream byteout = bytesList.get(i);       	 
                 ByteArray bytes =byteout.toByteArray();
                 bytes.writeTo(ostream);
            }
            log.debug("Committed buffered bytes to the Servlet output stream");
        }
        // 循环输出chars
        if (writer != null) {
        	PrintWriter printWriter = super.getWriter();
        	printWriter.write(header);
            flushBufferAdapter();
            for(int i =0 ;i<charsList.size();i++){
            	StringWriter stringwriter = charsList.get(i);        	
            	ResponseStringBuffer sb = stringwriter.getBuffer();
            	printWriter.write(sb.getData(),0,sb.length());
            	printWriter.flush();
            }
            charsList.clear();
            this.writer.close();
            this.writer=null;
            log.debug("Committed buffered characters to the Servlet writer");
        }
    }

    /**
     * 冲洗buffer adapter，确保adapter中的信息被写入buffer中。
     */
    private void flushBufferAdapter() {
        if (streamAdapter != null) {
            streamAdapter.flush();
        }

        if (writerAdapter != null) {
            try {
                writerAdapter.flush();
            } catch (IOException e) {
            }
        }
    }

    /**
     * 获取当前输出流的位置
     * @return
     */
    public String getBufferPosition() {
    	int size = 0;
    	int pos = 0;
    	if(writer != null ) {
    		if(charsList != null ) {
    			size = charsList.size() - 1;
    		}
    		pos = ((BufferedServletWriter)writer).getLen();
    	}
    	return size + " " + pos;
    }
    
    /**
     * 从Response输出流中读取数据
     * @param start
     * @return
     */
    public String readBuffer(String start) {
    	return readBuffer(start, getBufferPosition());
    }
    
    /**
     * 从Response输出流中读取数据
     * @param start
     * @param end
     * @return
     */
    public String readBuffer(String start, String end) {
    	String[] startPos = start.split(" ");
    	String[] endPos = end.split(" ");
    	int s = Integer.parseInt(startPos[0]);
    	int e = Integer.parseInt(endPos[0]);
    	int sp = Integer.parseInt(startPos[1]);
    	int ep = Integer.parseInt(endPos[1]);
    	
    	StringBuffer str = new StringBuffer();
    	for(int i=s ;i<e + 1;i++){
        	StringWriter stringwriter = charsList.get(i); 
        	ResponseStringBuffer sb = stringwriter.getBuffer();
        	
        	char[] chars = sb.getData();
        	int offset = 0;
        	int len = chars.length;
        	if(i == s) {
        		offset = sp;
        		len = len - offset;
        	}
        	if(i == e) {
        		len = ep - offset;
        	}
        	str.append(chars, offset, len);
        }
    	return str.toString();
    }
   

    /**
     * 代表一个将内容保存在内存中的<code>ServletOutputStream</code>。
     */
    private static class BufferedServletOutputStream extends ServletOutputStream {
        private ByteArrayOutputStream bytes;

        public BufferedServletOutputStream(ByteArrayOutputStream bytes) {
            this.bytes = bytes;
        }

        public void updateOutputStream(ByteArrayOutputStream bytes) {
            this.bytes = bytes;
        }

        @Override
        public void write(int b) throws IOException {
            bytes.write((byte) b);
        }

        @Override
        public void write(byte[] b) throws IOException {
            write(b, 0, b.length);
        }

        @Override
        public void write(byte[] b, int off, int len) throws IOException {
            bytes.write(b, off, len);
        }

        @Override
        public void flush() throws IOException {
            bytes.flush();
        }

        @Override
        public void close() throws IOException {
            bytes.flush();
            bytes.close();
        }
    }

    /**
     * 代表一个将内容保存在内存中的<code>PrintWriter</code>。
     */
    private static class BufferedServletWriter extends PrintWriter {
    	private int len=0;
    	private List<StringWriter> list =null;
        public BufferedServletWriter(StringWriter chars,List<StringWriter> charsList) {
            super(chars);
            this.list = charsList;
        }
        @Override
        public void close(){
        	this.list=null;
        	this.len=0;
        	super.close();
        }
        public void updateWriter(StringWriter chars) {
            this.out = chars;
        }
        @Override
        public void write(int c) {
        	isMax(len);
        	this.len +=1;
        	super.write(c);
        }
        @Override
        public void write(String str, int off, int len) {
        	isMax(len);
        	this.len +=len;
        	super.write(str,off,len);
        }
		@Override
		public void write(char[] buf, int off, int len) {	
			isMax(len);
			this.len +=len;
			super.write(buf, off, len);
		}
		private void isMax(int len){
			//判断，如果超过了最大值
			if(this.len+len>MAX){
				StringWriter chars = new StringWriter();
	            list.add(chars);
	            this.out = chars;
	            this.len=0;
			}
		}
		public int getLen() {
			return len;
		}
		public void setLen(int len) {
			this.len = len;
		}
    }

    /**
     * 将<code>Writer</code>适配到<code>ServletOutputStream</code>。
     */
    private static class WriterOutputStream extends ServletOutputStream {
        private ByteArrayOutputStream buffer = new ByteArrayOutputStream();
        private Writer writer;
        private String charset;

        public WriterOutputStream(Writer writer, String charset) {
            this.writer = writer;
            this.charset = charset;
        }

        @Override
        public void write(int b) throws IOException {
            buffer.write((byte) b);
        }

        @Override
        public void write(byte[] b) throws IOException {
            buffer.write(b, 0, b.length);
        }

        @Override
        public void write(byte[] b, int off, int len) throws IOException {
            buffer.write(b, off, len);
        }

        @Override
        public void flush() throws IOException {
            ByteArray bytes = buffer.toByteArray();

            if (bytes.getLength() > 0) {
                ByteArrayInputStream inputBytes = new ByteArrayInputStream(bytes.getRawBytes(), bytes.getOffset(),
                        bytes.getLength());
                InputStreamReader reader = new InputStreamReader(inputBytes, charset);

                io(reader, writer, true, false);
                writer.flush();

                buffer.reset();
            }
        }

        @Override
        public void close() throws IOException {
            this.flush();
        }
    }
    
    /**
     * 从输入流读取内容，写入到输出流中。
     */
    public static void io(Reader in, Writer out, boolean closeIn, boolean closeOut) throws IOException {
        int bufferSize = MAX >> 1;
        char[] buffer = new char[bufferSize];
        int amount;

        try {
            while ((amount = in.read(buffer)) >= 0) {
                out.write(buffer, 0, amount);
            }

            out.flush();
        } finally {
            if (closeIn) {
                try {
                    in.close();
                } catch (IOException e) {
                }
            }

            if (closeOut) {
                try {
                    out.close();
                } catch (IOException e) {
                }
            }
        }
    }
}
