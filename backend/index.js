//mongodb+srv://rishidogne:<db_password>@cluster0.1zyocmt.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0
const express = require('express');
const axios = require('axios');
const cors = require('cors');
const mongoose = require('mongoose');
require('dotenv').config();

const app = express();
app.use(cors({
  origin: '*',
  methods: ['GET', 'POST', 'DELETE'],
  allowedHeaders: ['Content-Type'],
}));
app.use(express.json());

const PORT = 5000;

// 🔗 MongoDB Atlas connection (replace placeholders)
mongoose.connect(process.env.MONGODB_ATLAS_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log("✅ Connected to MongoDB Atlas"))
.catch((err) => console.error("❌ MongoDB connection error:", err));

// 📦 Mongoose model for favorite articles
const articleSchema = new mongoose.Schema({
  title: String,
  description: String,
  urlToImage: String,
  url: String,
}, { timestamps: true });

const Article = mongoose.model('Article', articleSchema);

// 📰 Endpoint: Get top headlines
app.get('/news', async (req, res) => {
  const country = req.query.country || 'us';
  const category = req.query.category || '';
  const pageSize = 100;

  console.log(`🔍 Fetching top headlines from ${country}${category ? ' - ' + category : ''}`);

  try {
    const response = await axios.get('https://newsapi.org/v2/top-headlines', {
      params: {
        country,
        category,
        apiKey: process.env.NEWS_API_KEY,
        pageSize
      }
    });

    if (response.status === 200) {
      const articles = response.data.articles;
      console.log(`✅ Articles fetched: ${articles.length}`);
      res.json({ status: 'ok', total: articles.length, articles });
    } else {
      console.error(`❌ Error from NewsAPI: ${response.status}`);
      res.status(500).json({ error: 'Failed to fetch news' });
    }
  } catch (err) {
    console.error('🚨 NewsAPI fetch error:', err.message);
    res.status(500).json({ error: 'Failed to fetch news from NewsAPI' });
  }
});

// 🔎 Search News by Keyword
app.get('/search', async (req, res) => {
  const query = req.query.query;
  if (!query) {
    return res.status(400).json({ error: 'Query parameter is required' });
  }

  try {
    const response = await axios.get('https://newsapi.org/v2/everything', {
      params: {
        q: query,
        apiKey: process.env.NEWS_API_KEY,
        language: 'en',
        sortBy: 'publishedAt',
        pageSize: 20
      }
    });

    if (response.status === 200) {
      const articles = response.data.articles;
      console.log(`🔎 Search results: ${articles.length} articles for "${query}"`);
      res.json({ status: 'ok', total: articles.length, articles });
    } else {
      res.status(500).json({ error: 'Search failed' });
    }
  } catch (err) {
    console.error('❌ Search error:', err.message);
    res.status(500).json({ error: 'Search request failed' });
  }
});

// ❤️ POST: Save to favorites
app.post('/favorites', async (req, res) => {
  const { title, description, urlToImage, url } = req.body;

  try {
    const existing = await Article.findOne({ url });
    if (existing) {
      return res.status(200).json({ message: 'Article already in favorites' });
    }

    const article = new Article({ title, description, urlToImage, url });
    await article.save();
    res.status(200).json({ message: 'Article saved to favorites' });
  } catch (error) {
    console.error('Error saving favorite:', error);
    res.status(500).json({ message: 'Error saving article' });
  }
});

// 📋 GET: All favorite articles
app.get('/favorites', async (req, res) => {
  try {
    const favorites = await Article.find().sort({ createdAt: -1 });
    res.status(200).json(favorites);
  } catch (error) {
    console.error('Error fetching favorites:', error);
    res.status(500).json({ message: 'Error fetching articles' });
  }
});





// 🚀 Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running at http://localhost:${PORT}`);
});
